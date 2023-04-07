## default和delete

在C++03的标准里面，如果程序代码里面没有写默认构造函数(像`cv();`)、复制构造函数、复制赋值函数(像`cv cv2=cv1;`)和析构函数，则编译器会自动添加这些函数。当程序里面写了构造函数的时候，编译器就不会自动添加默认构造函数了。
那如果我想让一个类的实例不能通过复制构造函数来生成，该怎么办呢？一般的方法是将复制构造函数和复制赋值函数声明为`private`，而且不去具体实现它们，这样就达到了目的。
但这样做其实是很tricky的方式，相当于利用c++的一些特性碰巧来实现，总感觉不是正确的方法。
C++11里面可以用`default`来指定使用默认的构造函数，而且可以通过`delete`来显式地禁止一些方法，如复制构造函数和复制赋值操作，如下例：

```c++
struct NonCopyable{
	NonCopyable() = default;
	NonCopyable(const NonCopyable&) = delete;
	NonCopyable& operator=(const NonCopyable&) = delete;
};
```

这个例子里面，第一条语句是强制编译器生成默认构造函数作为struct的构造函数；第2、3条语句就是显式地禁用复制构造函数和复制赋值函数。