+++
date = "2017-05-07T23:00:00+08:00"
title = "C++测试框架Catch"
author = "Chen Yuan"
tags = ["C++"]
url = "post/cpp-test-framework-catch"
draft = false
+++
    
	
# Catch简介
Catch 一种是 C++ 测试框架。    
主要特点：    

- 配置简单，下载```catch.hpp```，然后```#include```即可。    
- 无需额外库依赖。只要能编译 C++ 98 和包含 C++ 标准库。    
- 编写测试用例与编写函数一样。    
- ```Section```中测试用例是独立运行的。    
- 兼容测试用例传统风格和BDD风格：```Given-When-Then```。   
- 条件比较是只用一个核心的警告宏。使用了标准的C/C++ 运算符重载功能。 

<!--more--> 
# Catch使用
## 1.获取Catch头文件
[Catch头文件](https://raw.githubusercontent.com/philsquared/Catch/master/single_include/catch.hpp)托管在GitHub上。下载保存至能包含的位置。
## 2.编写测试
准备要测试的函数，以斐波那契函数为例子。
```
unsigned int Factorial( unsigned int number ) {
    return number <= 1 ? number : Factorial(number-1)*number;
}
```
为简单描述，把函数放在一个的 C++ 代码文件中。
```
#define CATCH_CONFIG_MAIN  // This tells Catch to provide a main() - only do this in one cpp file
#include "catch.hpp"

unsigned int Factorial( unsigned int number ) {
    return number <= 1 ? number : Factorial(number-1)*number;
}

TEST_CASE( "Factorials are computed", "[factorial]" ) {
    REQUIRE( Factorial(0) == 1 );
    REQUIRE( Factorial(1) == 1 );
    REQUIRE( Factorial(2) == 2 );
    REQUIRE( Factorial(3) == 6 );
    REQUIRE( Factorial(10) == 3628800 );
}
```
编译运行上面代码。输出：
```
Example.cpp:9: FAILED:
  REQUIRE( Factorial(0) == 1 )
with expansion:
  0 == 1
```
有一个测试用例没通过，提示用例1的输出结果与预期的不一致。修改过斐波那契函数：
```
unsigned int Factorial( unsigned int number ) {
  return number > 1 ? Factorial(number-1)*number : 1;
}
```
重新编译运行，所有测试用例通过。
```
All tests passed(6 assertions in 1 test case)
```
## 3.分析
1. ```#definde CATCH_CONFIG_MAIN``` 和 ```#include "catch.hpp"```Catch测试的环境就配置好了，main()函数也不用写了。
2. ```TEST_CASE```宏需要1或2个参数，测试名称和测试标签（可选）
3. ```REQUIRE ```宏里面写测试用例判断公式。

# 另一个例子
```
#include <iostream>
#include <cstdlib>

#define CATCH_CONFIG_MAIN
#include "catch.hpp"

typedef struct TrieNode {
    bool completed;
    std::map<char, TrieNode *> children;
    TrieNode() : completed(false) {};
} TrieNode;

class Trie {
    public:
        Trie(void);
        ~Trie(void);
        void insert(std::string word);
        bool search(std::string word);
    private:
        TrieNode *root;
};

using namespace std;

TEST_CASE("Testing Trie") {
    // set up
    Trie *t = new Trie();

    // different sections
    SECTION("Search an existent word.") {
        string word = "abandon";
        t->insert(word);
        REQUIRE(t->search(word) == true);
    }
    SECTION("Search a nonexistent word.") {
        string word = "abandon";
        REQUIRE(t->search(word) == false);
    }

    // tear down
    delete t;
}
```
此处TEST_CASE里的两个section，第一个section是查找Trie中存在的单词，第二个section是查找Trie中不存在的单词。REQUIRE是Catch提供的宏，相当于assert，检验表达式是否成立。    

简单地讲，每个 TEST_CASE 由三部分组成，set up、sections 和 tear down，set up 是各个section都需要的准备工作，tear down是各个section都需要的清理工作，**set up和tear down对于每个section都会执行一遍。**    

比如有一个TEST_CASE:    
```
TEST_CASE {
    set up
    case 1
    case 2
    tear down
}
```
真正执行时就是：set up->case 1->tear down->set up->case 2->tear down。

# 参考资料
1.[Catch的官方手册](https://github.com/philsquared/Catch/blob/master/docs/tutorial.md)    

2.[测试C++程序：使用Catch和Valgrind](http://www.jianshu.com/p/6f03a0cfe60c)

