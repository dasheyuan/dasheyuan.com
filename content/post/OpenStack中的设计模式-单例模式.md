+++
date = "2016-02-14T21:30:28+08:00"
title = "OpenStack中的设计模式-单例模式"
author = "Chen Yuan"
tags = ["OpenStack","设计模式"]
disqusShortname="dasheyuan"
url = "post/2016-02-14"
+++

单例模式Singleton Pattern最初的定义出现于《设计模式》（艾迪生维斯理, 1994）：“保证一个类仅有一个实例，并提供一个访问它的全局访问点。”

对于面向对象编程，有一些对象其实只需要一个，比如：线程池、缓存、处理偏好设置和注册表的对象、日志对象等。事实上，这些对象只能有一个实例。单例模式与全局变量一样方便，又没有全局变量的缺点。
<!--more-->
如果程序中引入了多线程，那么需要对Singleton Pattern进行优化，一般 对线程敏感的资源(临界资源)进行加锁。


要点：单例模式确保程序中一个类最多只有一个实例；单例模式也提供这个实例的全局点；确定在性能和资源上的限制，然后小心地选择适当的方案来实现单例，以解决多线程的问题。
```
#Excerpted：oslo_service/service.py
class Singleton(type):
    _instances = {}
    _semaphores = lockutils.Semaphores()

    def __call__(cls, *args, **kwargs):#<--cls:str"OneClass"
        with lockutils.lock('singleton_lock', 
			semaphores=cls._semaphores):
            if cls not in cls._instances:
                cls._instances[cls] = 
			super(Singleton, cls).__call__(*args, **kwargs)
        return cls._instances[cls]
```
通过修饰(参考[廖雪峰的官方网站](http://t.cn/R25TzFl))的方式，class **Singleton**作为修饰函数**six.add_metaclass**的参数传入，被修饰的class **OneClass**实例化的对象**a**、**b**是相同的。

```   
@six.add_metaclass(Singleton)
class OneClass():
	pass

a = OneClass()
b = OneClass()
print(a==b)
#True
```
```

#Excerpted：six.py
def add_metaclass(metaclass):#<--metaclass:Singleton
    """Class decorator for creating a class with a metaclass."""
    def wrapper(cls):#<--cls:OneClass
        orig_vars = cls.__dict__.copy()
        slots = orig_vars.get('__slots__')
        if slots is not None:
            if isinstance(slots, str):
                slots = [slots]
            for slots_var in slots:
                orig_vars.pop(slots_var)
        orig_vars.pop('__dict__', None)
        orig_vars.pop('__weakref__', None)
        return metaclass(cls.__name__, cls.__bases__, orig_vars)
		#<--Singleton(OneClass,(),orig_vars)
    return wrapper
```

----------


Python 语法(参考[官网](https://docs.python.org/2.7/))：
````
 1. object.__call__(self [, args...]) 
Called when the instance is“called” as a function; if this method is defined, x(arg1, arg2, ...) is a shorthand for x.\__call__(arg1, arg2, ...).
 2. class.__name__
The name of the class or type.
 3. class.__bases__
The tuple of base classes of a class object.
 4. __slots__
This ***class variable*** can be assigned a string, iterable, or sequence of strings with variable names used by instances. If defined in a new-style class, __slots__ reserves space for the declared variables and prevents the automatic creation of **__dict__** and **__weakref__** for each instance.
 5. instance.__class__
The class to which a class instance belongs.
````
> object、class和instance的联系
> 这个对象object（class）自身拥有创建对象object（instance）的能力，而这就是为什么它是一个类class的原因。(参考[metaclass](http://blog.jobbole.com/21351/))
> 一切皆object

Singleton中定义的类属性_instance，类变量对所有对象唯一，即所有实例都有唯一的属性_instance