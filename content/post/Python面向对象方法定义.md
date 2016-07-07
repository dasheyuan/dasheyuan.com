+++
date = "2016-06-25T23:00:00+08:00"
title = "Python面向对象方法的定义方式"
author = "Chen Yuan"
tags = ["python"]
url = "post/python-object-method-define"
draft = false
+++
Python面向对象的方法(函数)定义方式通常有三种：
```
class A(object):
    # 普通方法
    def foo(self,x):
        print "executing foo(%s,%s)"%(self,x)

    # 类方法
    @classmethod
    def class_foo(cls,x):
        print "executing class_foo(%s,%s)"%(cls,x)

    # 静态方法
    @staticmethod
    def static_foo(x):
        print "executing static_foo(%s)"%x
```
定义方式不同点：修饰函数和函数参数。    
普通方法没有修饰函数，函数参数中第一个是`self`，指向特定的实例；    
类方法需要`@classmethod`函数装饰，函数参数中第一个是`cls`，指向这个类；    
静态方法需要`@staticmethond`函数装饰，函数参数可以不指定。

普通方法用了实现具体实例的的函数；    
类方法用来管理类的函数，比如记录类的实例个数；    
静态方法被用来组织类之间有逻辑关系的函数。
<!--more-->  
另外，常见的使用`@property`及`@setter`装饰器定义的方法：
```
class Student(object):

    @property
    def birth(self):
        return self._birth

    @birth.setter
    def birth(self, value):
        self._birth = value

    @property
    def age(self):
        return 2016 - self._birth
```
```
s=Student()
s.birth=1991
print s.birth
# 1991
print s.age
# 25
```
为什么要使用这种方式呢？    

因为在绑定属性时，如果我们直接把属性暴露出去，虽然写起来很简单，但是，没办法检查参数，导致可以把属性的值随意改变。    

这不合逻辑，也不安全。一般是通过get与set方法来获得和改变属性的值。但Pythoner认为这样这样访问属性的方法调用繁琐。    

有没有既能检查参数，有可以类似属性暴露的方式来访问属性的值呢？    

Python内置的`@property`装饰器的作用就是把一个方法变成属性调用，`@setter`装饰器与`@property`结合使用，这样定义的方法既可类似属性一样直接访问和设置，同时还能再方法中检查参数。


##  参考
1. [装饰器@staticmethod和@classmethod有什么区别?](https://taizilongxu.gitbooks.io/stackoverflow-about-python/content/14/README.html)


