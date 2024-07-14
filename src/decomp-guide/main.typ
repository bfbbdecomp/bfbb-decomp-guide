
#let functions = (
  ("The Simplest Function: Nothing", <fn.nothing>),
  ("Returning Values", <fn.return>),
  ("A Function with Some Logic", <fn.nothing>),
  ("A Function with a For Loop", <fn.for>),
  ("A Function with a Switch Statement", <fn.switch>),
  ("A Large Function", <fn.large>),
)


= Decompilation Guides

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
  #lorem(20)
  #(i += 1)
]