
== What is Decompilation?

Let's take a moment to define some foundational terms that will help us understand what decompilation is and also be useful going forward:

#v(0.5cm)

/ Machine Code: Computer code consisting of machine language instructions, which are used to directly control a computer's central processing unit (CPU).

/ Assembly Language: A low-level programming language with a very strong correspondence between the instructions in the language and the architecture's machine code instructions.

/ High Level Language: A programming language with strong abstraction from the details of the computer. It may use natural language, making the process of developing a program simpler and more understandable than when using a lower-level language.

/ Compiler: A computer program that translates computer code written in one programming language (the source language) into another language (the target language).

- The name "compiler" is primarily used for programs that translate source code from a high-level programming language to a low-level programming language (e.g. assembly language, object code, or machine code) to create an executable program.

/ Decompilation: A type of reverse-engineering that performs the opposite operations of a compiler.

/ Type: A description of a set of values and a set of allowed operations on those values

/ Statically Typed Language: A language is statically typed if the type of a variable is known at compile time.

- The main advantage here is that all kinds of checking can be done by the compiler, and therefore a lot of trivial bugs are caught at a very early stage.
- Examples: C, C++, Java, Rust, Go, Scala

/ Dynamically Typed Language: A compiler or an interpreter assigns a type to all the variables at run-time. The type of a variable is decided based on its value.

- Programs written using dynamically typed languages are more flexible but will run even if they contain errors.
- Examples: Perl, Ruby, Python, PHP, JavaScript, Erlang


#v(0.5cm)

When most people talk about programming today, they are almost always referring
to high level programming languages.
Programming languages come in all shapes and sizes,
and each one offers a different level of capabilities and abstraction.
Some are dynamically typed, some are statically typed.
Some are interpreted, some are compiled.
Each programming language varies in ease of use, performance, safety, and other factors.

#let left = [

Battle for Bikini Bottom is written in the *C++* programming language.
// TODO: come back and link to proper chapter
In later chapters we will discuss how this fact was discovered
and what implications it has on the decompilation project.

C++ is a statically typed, compiled programming language
that has been around since 1985.
It is a very common choice for building game engines
because it generates extremely fast machine code
while at the same time being expressive
and generally straightforward to program in.

The C++ compilation process involves
a series of steps which translate
the original human written source code
into what ultimately becomes
an executable file.
Refer to @compilation-process for an illustration of this process.

]

#grid(
  columns: (40%, 60%),
  left, 
  [#figure(
    caption: [The C++ compilation process],
    image("img/compilation.png")
  )<compilation-process>]
)

If the compilation process is a series of steps 
from $A -> B$,
then the decompilation process is simply the same process in reverse
from $B -> A$.
and it looks like this:

#figure(
  caption: [The decompilation process],
  image("img/decompilation.png", width: 70%)
)

It's important to understand that going in reverse is not something that can be done automatically in the same way that source code is compiled to machine code.
Decompilation requires reverse engineering the machine code to understand the intent,
and rewriting code at a high level which matches the same logic.

The process is like trying to deduce the original recipe used to make a cake,
except the only thing you have to work with is the cake which has already been baked.
