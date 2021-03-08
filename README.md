# Cool-Compiler

[COOL](https://en.wikipedia.org/wiki/Cool_(programming_language)) (the Classroom Object-Oriented Language) is a small language designed for use in an undergraduate compiler course project. While small enough for a one term project, Cool still has many of the features of modern programming languages, including objects, automatic memory management, and strong static typing. The course is accessible freely on many platforms such as [EDX](https://www.edx.org/course/compilers?index=product&queryID=a1c87b3bacffac5ca467cc70f888188d&position=1). 
The project is organized into 4 independant components that glue together to produce a working compiler.
* The lexical analyzer
* The parser
* The semantic analyzer
* The code generator

The lexical analyzer is written in [Flex](https://garudaxc.github.io/BisonTest/#SEC_Contents), the parser in [Bison](https://www.gnu.org/software/bison/manual/html_node/index.html#SEC_Contents) the semantic analyzer and code generator in C++.

### Example

```
class Main inherits IO {
	main(): Object { 
		out_string("hello world.\n") 
	};
};

```

### Next
* Use [LLVM](https://llvm.org/) to generate code therefore support more architectures
* Refactor the code to support modern cpp programming style
* Code my own lexer and parser in place of using existing tools