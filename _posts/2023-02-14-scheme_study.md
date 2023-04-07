---
layout: post
custom_js: mouse_coords
date: 2023-02-14
---
### 组合式的求值

运算符加上参数，用括号括起来



### 环境

定义的默认运算符



### define的用法

define是一种特殊形式，语法为

```scheme
(define (<name> <parameters>)  <body> 
)
//1.平方举例
(define (square x) (* x x)  )
//2.x的平方和y的平方和举例(x^2+y^2)
(define (sum-of-squares x y)
  (+ (square x) (square y))  
)
```



### 代换模型

将变量代换为实际的值，并用来推算求值（手动或者是打印解释器日志）



### 条件判断

关键字是cond（表示“条件”）

```scheme
(define (abs x)
	(cond ((> x 0)  x)
   			((= x 0)  0)
        ((< x 0) (-x) )
  )  
)

(define (abs x)
	(cond ( (< x 0) (-x)
         (else x) 
        )
  )  
)

//cond的一般性形式为(p是谓词，或者说一个表达式，将被解释为true或者false)
(cond (<p1> <e2>)
      (<p2> <e3>)
      (<pN> <eN>)
)
```

还可以使用if
if只有两个条件，若pre为真，则求出con里的值并返回，否则求出al的值并返回

```scheme
(if <predicate> <consequent> <alternative>)

//举例
(define (abs x)
	(if (<x 0))
)
```

其他谓词

and/or/not

```scheme
(and <e1> <e2> <eN>)
(or <e1> <e2> <eN>)
(not <e>)
```



### 使用牛顿迭代法求平方根

```scheme
//对x的平方根的值有一个猜测y（第一个y一般为1）
//那么求出y和x/y的平均值（更接近实际的平方根值）
//例如：需要求出4的平方根（初始猜测为1）
//猜测1，商4/1=4，平均值(1+4)/2=2.5（这里需要做误差比较，符合误差比较或者为猜测值就返回）
//猜测为2.5，商4/2.5=1.6，平均值为(2.5+1.6)/2=2.05
//猜测为2.05，商4/2.05=

//主要迭代
(define (sqrt-iter guess x)
  (if (good-enough? guess x)
      guess
      (sqrt-iter (improve guess x)
                 x
      )
  )
)
//提升猜测精度
(define (improve guess x)
  (average guess (/ x guess) )
)
//求平均值
(define (average x y)
  (/ (+ x y) 2)
)
//误差设定（”足够好“的定义）
(defeine (good-enough? guess x)
  (< (abs (- (square guess) x)) 0.001)
)
//初始猜测设为1（实际设为x/2更好，不过不影响）
(define (sqrt x)
  (sqrt-iter 1.0 x)
)
```

