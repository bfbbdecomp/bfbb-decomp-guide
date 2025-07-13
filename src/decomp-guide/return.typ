#show link: underline

To introduce the assembly/C++ concepts required to understand functions
which return data, we will start by analyzing the assembly code for
one of the most classical function types in all of programming: the Getter.

A "getter" function is a function which simply returns a value.
It is often used in Object-Oriented Programming languages to prevent
unintended usage of values that only a particular class or file should
be using, and helps create an easy-to-understand interface to those values.

Here's an example of a "getter" function from `xLightKit.cpp` in the BfBB
decomp project which will be the study of this section:
```cpp
xLightKit* xLightKit_GetCurrent(RpWorld* world)
{
    return gLastLightKit;
}
```

We will break this function down into its components shortly, but what
you should notice is that the function only has a single C instruction
here: return the data stored in `gLastLightKit`. Studying the assembly
that goes into this simple operation will help us understand what is
happening in more complex functions which also return data.

Let's start by creating our initial declaration using Objdiff.

=== Creating the Function Declaration

Let's say we have opened up Objdiff and we want to work on the last
missing function in the file xLightKit.cpp, `xLightKit_GetCurrent`:

#image("return_imgs/filelist.png")

We can use Objdiff's symbol mapping capabilities to get our declaration started
by right-clicking the function we want to work on and copying the
demangled, mapped function name (2nd item in the popup menu):
#image("return_imgs/objdiff_demangle.png")

Doing that, we know that our declaration should start to look like this:
```cpp
... xLightKit_GetCurrent(RpWorld*);
```

However, we are still missing the required return type for this declaration.
Let's inspect the PS2 DWARF data to see if it's any help here:
```cpp
/*
    Compile unit: C:\SB\Core\x\xLightKit.cpp
    Producer: MW MIPS C Compiler
    Language: C++
    Code range: 0x00305BD0 -> 0x00305BD8
*/
// Range: 0x305BD0 -> 0x305BD8
class xLightKit * xLightKit_GetCurrent() {
    // Blocks
    /* anonymous block */ {
        // Range: 0x305BD0 -> 0x305BD8
    }
}
```

We're in luck! There is DWARF data for this function.
Based on this, we're able to see that the `xLightKit_GetCurrent`
has a return type in the DWARF data of `class xLightKit*`. We can apply that
to our working function declaration:
```cpp
class xLightKit* xLightKit_GetCurrent(RpWorld*);
```

Note that the DWARF data does not show that this function had any parameters
on the PS2 version of the game. We will see soon that the function does not actually
make use of this parameter, but it should be included nonetheless because Objdiff
tells us that it is present in the GCN version of the code, which is our single Source
of Truth. It may be that some debugging code excluded from the GCN release build
of the game made use of this parameter, but it's not possible to say for sure.

There are some final refinements we can make to this declaration.
"`class xLightKit*`" is what is known as an _elaborated type specifier_, which can be
used in cases where a type name conflicts with a local variable name. Since in practice
this is very rare, we can shorten this to simply include the type:
```cpp
xLightKit* xLightKit_GetCurrent(RpWorld*);
```

As a final touch, let's give our unused `RpWorld*` parameter a descriptive symbol name.
```cpp
xLightKit* xLightKit_GetCurrent(RpWorld* world);
```

And there is our function declaration! We can now pop this into `xLightKit.h` in
the appropriate spot:
```cpp
// xLightKit.h
...

xLightKit* xLightKit_Prepare(void* data);
void xLightKit_Enable(xLightKit* lkit, RpWorld* world);
xLightKit* xLightKit_GetCurrent(RpWorld* world);  // Our new declaration!
void xLightKit_Destroy(xLightKit* lkit);

...
```

=== Calling Conventions and Returning a Register Value

Now that we've got our function declaration setup, we can add our implementation stub
to `xLightKit.cpp`:
```cpp
xLightKit* xLightKit_GetCurrent(RpWorld* world)
{
    // TODO: Implement me
}
```

Attempting to build for the moment will yield the following compiler error:
```

User break, cancelled...
#    File: src\SB\Core\x\xLightKit.cpp
# ------------------------------------
#     122: }
#   Error: ^
#   return value expected
#   Too many errors printed, aborting program
ninja: build stopped: subcommand failed.
```

As the compiler says, a return value is expected for this function, but we have yet to
implement that, and so a compiler error occurs.

Let's begin analyzing the assembly code for this function so that we can
return the value the compiler expects!
```
0:    lwz          r3, gLastLightKit@sda21
4:    blr
```

In the prior case study, we learned that the `blr` instruction will exit an
assembly subroutine and jump back to the subroutine pointed at by the value
stored in the link register. Our C instruction equivalent is the simple
```cpp
return;
```

However, this is not enough to return a value. To do that, we will need to
understand a bit about assembly function calling conventions.

While high-level programming languages like C++ or Java let you clearly state what a
function returns and what parameters it receives, assembly language does not have
built-in ways to pass information between functions. Instead, functions must use CPU
registers or program memory to share data. To make sure all functions agree on how to do this,
CPU designers define *calling conventions*. Calling conventions are rules that say where
to put things like parameters and return values when calling and returning from a function.

The PowerPC CPU architecture supports user access of two types of registers:
general-purpose and floating point registers #footnote("https://datasheets.chipdb.org/IBM/PowerPC/Gekko/gekko_user_manual.pdf").
There are 32 registers of both types, all of which are freely available for programmers
to use as needed.

By calling convention, parameters to an assembly function (called a subroutine) are passed
starting at `r3` and/or `f1`. For example, the C function:
```cpp
void exampleFunction(U8 id, S32 isSpunch, F32 dt, F64 yPos);
```

would have the following values in registers at the beginning of its assembly subroutine
analogue:
```
r3 - id
r4 - isSpunch
f1 - dt
f2 - yPos
```

Now for return values. By calling convention, values to be returned to the calling subroutine
are stored into f1 is the value is a float, or r3 otherwise.

Knowing this, we can now figure out how the `blr` instruction is supported in order to return
a value. The previous instruction:
```
0:    lwz          r3, gLastLightKit@sda21
```
loads the value of the global variable `gLastLightKit` into the r3 register. Immediately following
this, the `blr` instruction is called, which will exit the subroutine.

Since we know that the assembly code loads `gLastLightKit` into the r3 register prior
to returning from the subroutine, we know that the decompiled C equivalent will return
the value gLastLightKit. We can achieve that by using the following return syntax:
```cpp
return gLastLightKit;
```

Combining everything we've done up to this point, we get what we set out to decompile:
```cpp
xLightKit* xLightKit_GetCurrent(RpWorld* world)
{
    return gLastLightKit;
}
```

Et voila - building this via Objdiff will now produce a 100% match!
#image("return_imgs/final_comparison.png")

Hopefully you're beginning to feel a little bit more familiar with some assembly
programming constructs by this point. After completing this decompilation exercise,
we've so far learned the following:
- How to use the PS2 DWARF data to validate function return types
- PowerPC Calling Conventions for Function Parameters and Return Values
- How to use calling conventions when decompiling functions that return a value

In the next exercise, we will continue by introducing functions which include
branching and conditional operations.
