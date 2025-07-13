
#let functions = (
  ("The Simplest Function: Nothing", <fn.nothing>, "nothing.typ"),
  ("Returning Values", <fn.return>, "return.typ"),
  // ("A Function with Some Logic", <fn.small>, "return.typ"),
  // ("A Function with a For Loop", <fn.for>, "return.typ"),
  // ("A Function with a Switch Statement", <fn.switch>, "return.typ"),
  // ("A Large Function", <fn.large>, "return.typ"),
)



= Decompilation Guides

Welcome to the exciting part of the book!
We finally get to get our hands dirty and start decompiling some code.
This chapter is going to walk you through the process of decompiling
#functions.len() functions.
They are going to start off as easy as possible
and slowly increase in complexity.
Each one will teach you something new
about how the MetroWerks PowerPC compiler translates
C++ language features into assembly language.


#let i = 1
#for value in functions [
  == #i. #value.at(0) #value.at(1)
  #include value.at(2)
  #(i += 1)
]
