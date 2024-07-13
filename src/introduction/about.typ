
== About this Book

Welcome to the exciting world of video game decompilation!
This book serves as an introduction to the BFBB Decompilation Project
#footnote("https://github.com/bfbbdecomp"),
which is an organized community effort to reverse engineer the source code of
the 2003 platform game "SpongeBob SquarePants: Battle for Bikini Bottom" (BFBB) for Nintendo GameCube.


=== What you will learn

The main goal of this book is to act as a complete guide that can take someone
(with the #link(<knowledge>, [#underline[required prerequisite knowledge]]))
from zero understanding of decompilation and assembly code to being able to read, understand, and 
decompile BFBB's C++ source code and corresponding assembly code.
It also aims to answer any and all questions
that you might have related to any aspect of the project.


So what does this mean for you?

If you read through this book
you will learn about BFBB's game engine,
the decompilation process,
and how C++ code translates to assembly.
You will see examples of how real game functions are decompiled
from nothing but bytes.
You will deepen your understanding of computer science,
You will gain the knowledge required to be able to create your own custom mods
and builds of BFBB.
And most excitingly,
you will get an exclusive look behind the curtains at the source code of
one of your favorite childhood games
and see how the sausage is made.

Your reverse engineering effort will
unearth and give new life to long lost-and-forgotten source code
as if you were a digital archeologist.
It is also likely that your newly decompiled code will run on hundreds of thousands
if not millions of PCs
as the source code will serve as the base for a highly desired native BFBB PC port
(and to perhaps other platforms).

You have an opportunity to become a part of gaming history.


== Prerequisite Knowledge <knowledge>

Reverse engineering is an advanced topic.
The goal of this book is to break it down into digestible parts
that make it easy to follow along and learn.
However, the contents of this book are written in a way that assumes that the reader 
has a comfortable foundational understanding of programming and computer science.

=== What you need to know

Here are a list of things that you #underline([do]) need to know before reading this book.

+ A moderate familiarity with C++ and the language features that the BFBB codebase makes heavy use of:
  - Classes, Inheritance, and Object Oriented Programming
  - Polymorphism (Virtual Functions)
  - Pointers and References
  - Callback Functions
  - Casting
+ Have an enthusiasm for BFBB and/or reverse engineering
+ How to use Git

Note that a lack of experience with C++ can be made up for with a solid understanding of programming in general.
What ultimately matters is that you have a solid understanding of how to write code.

It is unreasonable to expect to be able to understand or follow along
with this book without having ever written code before.
If you are interested in the topic of this book but have never written code,
it is recommended to learn programming fundamentals,
along with each one of the bullet points above and then come back
with some experience.

=== What you don't need to know

Here are a list of things that you #underline("don't") need to know beforehand.
If you do know them, it's a large plus, but if you don't, don't worry.
You will learn these things while reading this book:

+ How to write or read assembly language, be it PowerPC or any other type of instruction set
+ How to use Ghidra or other binary analysis/reverse engineering tools
+ Math, or anything related to 3D programming
+ Game development or game programming techniques

#quote(attribution: [You, probably right now], block: true)[
But how can we decompile a 3D game without needing to know game programming or 3D math?
]
// TODO: link to the idea later
Great question!
We will explain this idea in more detail later,
but the answer is surprisingly simple: 
The compiler will tell you if you're right or wrong.

For now think of it like this:

Imagine you have the formula $x + 1 = 4$.
There are an infinite amount of numbers you can substitute for $x$,
but there is only one correct answer.
You don't have to know anything about the number $4$,
or why the number $4$ is important in this context,
or about $x$,
or why we are adding instead of dividing,
or what the formula means.
You just have to solve for $x$ and that's it.
When you realize that $x = 3$ you're done.
You can forget about it and move on.

The decompilation process is similar.
Generally speaking there is only one way to write code
that will compile to the same assembly output.
You don't have to even know what the code is trying to do,
you just have to replicate the logic.