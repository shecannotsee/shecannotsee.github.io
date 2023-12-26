---
layout: post
categories: blog

---

## 1.背景

最近在写单元测试，势必就要涉及到对一些函数或者类对象 mock 。

当在 linux 下使用 gtest 以及 gmock 做 c/c++ 代码的单元测试时，就会涉及到一些系统函数例如 fopen, open ,close 等函数的 mock 。这时想起陈硕的书《Linux多线程服务端编程：使用muduoC++网络库》中 12.4 有谈到《在单元测试中mock系统调用》。由于项目在最开始编写的时候没有考虑到要做单元测试，所以就只能通过 12.4.2 中描述的来处理 mock 系统调用了。

为了做验证，我重构了我测试项目中的[googletest模块](https://github.com/shecannotsee/sheTestcode/tree/master/googletest_test)中的一些代码(commit-id:b0f32b00d2dc457593943aa259490750810c31be)，主要体现在[t4_system_interface_mock.cpp](https://github.com/shecannotsee/sheTestcode/blob/master/googletest_test/t4_system_interface_mock.cpp)中。

## 2.实现与细节

代码均基于陈硕的《Linux多线程服务端编程：使用muduoC++网络库》中的代码进行修改

### (1)获取要 mock 的系统函数信息

例如对于 fopen 系统函数，我们可以轻易获取到他的函数定义

```c
extern FILE *fopen (const char *__restrict __filename,
		            const char *__restrict __modes) __wur;
```

然后去掉一些我们不关心的信息可以获得一个比较简洁的 C 函数接口

```c
FILE *fopen(const char *__filename,
		    const char *__modes);
```



### (2)处理一些必要信息

#### 1-声明一个函数指针；

```c++
typedef FILE* (*fopen_func_t)(
  const char *__restrict __filename,
  const char *__restrict __modes);
```

#### 2-实例化该函数指针指针；

通过 dlsym 获取系统函数的真实地址（调用这个函数指针的实例的时候，就会动态获取到系统函数的真实地址，实现动态切换 mock 函数和真实系统调用）。

```c++
fopen_func_t fopen_func = reinterpret_cast<fopen_func_t>(dlsym(RTLD_NEXT,"fopen"));
```

#### 3-然后设置一些 mock 的参数和分支；

这里的代码和书上不太一样，因为我按照我的想法稍微修改了一些。

```c++
static bool mock_fopen = false; // mock 开关
constexpr int mock_fopen_errno = 1; // 因为这个我基本没有用到，所以我做了一些简化处理
enum class fopen_case_des : int { // 该枚举类主要用来处理 mock 中的各种返回
  ret_nullptr,
  ret_FILE,
};
static fopen_case_des fopen_case = fopen_case_des::ret_nullptr; // 初始化分支
```

#### 4-编写 mock 系统函数；

```c++
extern "C" FILE* fopen(const char *__restrict __filename,
                       const char *__restrict __modes) {
  if (mock_fopen) {
    if (fopen_case == fopen_case_des::ret_nullptr) {
      return nullptr;
    } else if (fopen_case == fopen_case_des::ret_FILE) {
      return new FILE;
    } else {
      return nullptr;
    }
  } else {
    return fopen_func(__filename, __modes);
  }
}
```



### (3)在单元测试中使用

#### 1-调用系统接口的函数；

fclose 的 mock 做了省略，可以去查看项目的源代码，里面有响相应的完整实现）；

```c++
int test_function_with_system_interface() {
  const std::string file_path = "../README.md";

  // open file
  FILE* file_handle = fopen(file_path.c_str(), "r");
  if (file_handle == nullptr) {
    return -1;
  }

  // close file
  if (fclose(file_handle) != 0) {
    return -2;
  }

  return 0;
}
```

#### 2-在 gtest 的 TEST 组件里实现走遍所有分支；

```c++
TEST(t4_system_interface_mock, linux_system_interface) {
  mock_fopen = true; // 开启 mock fopen
  mock_fclose = true; // 开启 mock fclose

  // The code wants the function to return -1
  fopen_case = fopen_case_des::ret_nullptr; // 让 fopen 走指定分支并且指定返回值
  fclose_case = fclose_case_des::ret_0; // 让 fclose 走指定分支并且指定返回值
  EXPECT_EQ(test_function_with_system_interface(), -1); // return -1 

  // The code wants the function to return 0
  fopen_case = fopen_case_des::ret_FILE; // 同理
  fclose_case = fclose_case_des::ret_0; // 同理
  EXPECT_EQ(test_function_with_system_interface(), 0); // return 0

  // The code wants the function to return -2
  fopen_case = fopen_case_des::ret_FILE; // 同理
  fclose_case = fclose_case_des::ret_1; // 同理
  EXPECT_EQ(test_function_with_system_interface(), -2); // return -2
    
  // 显示关闭 mock 从而不影响其他地方的使用
  mock_fopen = false; // close mock fopen
  mock_fclose = false; // close mock fclose
}
```

至此，我们完成了系统函数的 mock 。
