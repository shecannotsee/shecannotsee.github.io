---
layout: post
categories: blog
---



copy and move sample:

```c++
class foo {
 public:
  // constructors
  foo() = default; // default
  foo(const foo&) = default; // copy
  foo(foo&&) = default;      // move
    
  // assignment operator
  foo& operator=(const foo&) = default; // copy
  foo& operator=(foo&&) = default;      // move
    
  // destructors
  ~foo() = default;
};
```



对于拷贝构造，流程如下：

1. 从传入类将资源拷贝到本类中，通常通过成员初始化列表进行，也就是冒号的形式。



对于移动构造（需要声明为`noexcept`），流程如下：

1. 从传入类将资源**移动**到本类中
2. 由于是移动，所以在移动过后还要考虑对**传入类**的资源初始化



对于拷贝赋值，流程如下：

1. 检查自赋值，如果需要的话
2. 由于要拷贝到本类中，所以要对于本类的资源做相应的释放，主要是针对堆内存
3. 从传入类将资源**拷贝**到本类中
4. 返回`*this`



对于移动赋值（需要声明为`noexcept`），流程如下：

1. 检查自赋值，如果需要的话
2. 由于要移动到本类中，所以要对于本类的资源做相应的释放，主要是针对堆内存
3. 从传入类将资源**移动**到本类中
4. 由于是移动，所以在步骤3过后还要考虑对传入类的资源初始化
5. 返回`*this`
