
We're going to start off by decompiling
the simplest type of function in the game:
A function that does nothing.

An empty function is a function that has no logic.
It literally doesn't do anything.
In C++ a function that does nothing could look like this:

#grid(
  columns: (50%, 50%),
  ```cpp
  void DoNothing()
  {
  }
  ```,
  ```cpp
  void DoNothing()
  {
      return;
  }
  ```,
)

Note that we can choose whether or not to write the `return;` keyword.
It doesn't make a difference whether we write it out or not.

#grid(
  columns: (50%, 50%),
  [
    Since the function is void, nothing is returned,
    so both of these functions
    are compiled down to a single `blr` assembly instruction:
  ],
  image("nothing/nothing.png"),
)

What does the assembly instruction `blr` mean?

#v(0.5cm)
/ blr: "Branch to Link Register". Jumps to lr. Used to end a subroutine.
#v(0.5cm)

=== What is a Link Register?

_A link register (LR for short) is a register which holds the address to return to when a subroutine call completes. This is more efficient than the more traditional scheme of storing return addresses on a call stack, sometimes called a machine stack. The link register does not require the writes and reads of the memory containing the stack which can save a considerable percentage of execution time with repeated calls of small subroutines.
The IBM POWER architecture, and its PowerPC and Power ISA successors, have a special-purpose link register, into which subroutine call instructions put the return address._
#footnote("https://en.wikipedia.org/wiki/Link_register")

So the `lr` register is special and holds the return address for the CPU to
jump back to when the current subroutine finishes.
This means that every function in the game is going to end with a `blr` instruction.

This example function `DoNothing` is only made up of one instruction.
Since every PowerPC assembly instruction is 4 bytes in size,
The total size of this function is 4 since it is just one `blr` instruction.
Size 4 functions are the smallest functions you will find.

Fun fact: There are 318 functions in the game that do nothing.
If we add up their size,
we get a total size of $318 * 4 = 1272$ bytes.
One other way of saying this is that
$0.07%$ of the entire game's code does nothing!

Since we have a general idea of what an empty function is like,
let's now decompile an empty function in BFBB.

=== Our First Function -- NPCWidget::Reset()
We are going to look at the function `NPCWidget::Reset()`.
It is a size 4 function located in the file
`/Game/zNPCSupport.cpp`.

If we open up `zNPCSupport` in Objdiff and click on `NPCWidget::Reset()`,
we can see the original assembly on the left, and nothing on the right.

#image("nothing/reset.png")

We can see that the original assembly on the left just has one instruction,
a `blr` instruction like we expect.
When the right side says "Missing", this means that
we have yet to define the function in our game source file.
This is to be expected at this point because we haven't decompiled this function yet.

Let's go ahead and define this function in our C++ source file `zNPCSupport.cpp`:

```cpp
void NPCWidget::Reset()
{
}
```

Great! We've defined our function.
When we go back and look at Objdiff,
it looks like there was an error compiling `zNPCSupport.cpp`:

```
### mwcceppc.exe Compiler:
#    File: src\SB\Game\zNPCSupport.cpp
# ------------------------------------
#      25: void NPCWidget::Reset()
#   Error:      ^^^^^^^^^
#   undefined identifier 'NPCWidget'
#   Too many errors printed, aborting program
```

The error is pretty straight-forward.
The compiler can't find any kind of definition for the type `NPCWidget`.

*Classes and Member Functions*

This function isn't _quite_ as simple as our example `DoNothing` function we saw earlier.
In this case, `Reset()` is actually a member function of the `NPCWidget` class,
which is why we see the scope resolution operator, AKA double-colon (`::`) in `NPCWidget::Reset()`.

We need to define the type of `NPCWidget`.

// TODO: replace this link with the proper dwarf section
We can search all of the files in the BFBB repository and we can see that
we haven't yet defined `NPCWidget` in any of our source headers.
This means that we need to add it ourselves.

But how do we know what the type of `NPCWidget` is?
To answer this question, we're going to reference the PS2 DWARF Data.
If we search for `NPCWidget` in the PS2 DWARF data file, (defined in Section TODO)
We can see the definition for the class here:

```cpp
class NPCWidget {
    // total size: 0xC
public:
    enum en_NPC_UI_WIDGETS idxID; // offset 0x0, size 0x4
    class xBase * base_widge; // offset 0x4, size 0x4
    class zNPCCommon * npc_ownerlock; // offset 0x8, size 0x4
};
```

We can simply copy and paste this into the accompanying header file `zNPCSupport.h`.
After we do this, Objdiff thanks us for our effort by greeting us with a new error:

```
### mwcceppc.exe Compiler:
#      In: src\SB\Game\zNPCSupport.h
#    From: src\SB\Game\zNPCSupport.cpp
# ------------------------------------
#      22: enum en_NPC_UI_WIDGETS idxID; // offset 0x0, size 0x4
#   Error:                        ^^^^^
#   undefined identifier 'en_NPC_UI_WIDGETS'
#   Too many errors printed, aborting program
```

Again, the error message is pretty clear.
We need to define `en_NPC_UI_WIDGETS`.
Once again, we can't find this enum defined anywhere in
our source header files yet, so it means that it hasn't
been copied over yet.
Let's do that now.
Heading back over to the PS2 DWARF file, we can search for
`en_NPC_UI_WIDGETS` and we find this enum:

```cpp
enum en_NPC_UI_WIDGETS {
    NPC_WIDGE_TALK = 0,
    NPC_WIDGE_NOMORE = 1,
    NPC_WIDGE_FORCE = 2,
};
```

Once again, we want to copy this type over into our `zNPCSupport.h` file.
We have to make sure that we put this definition before the definition of
`NPCWidget`, as that class references the enum.

Back in Objdiff, unsurprisingly, we have another error:
```
### mwcceppc.exe Compiler:
#    File: src\SB\Game\zNPCSupport.cpp
# ------------------------------------
#      26: {
#   Error: ^
#   undefined identifier 'Reset'
#   Too many errors printed, aborting program
```

This one is simple though. It's just saying that
the `Reset()` function isn't defined in `NPCWidget`.
We can fix this by defining the `Reset` method with a `void` return type on our class:

```cpp
class NPCWidget
{
    // total size: 0xC
public:
    enum en_NPC_UI_WIDGETS idxID; // offset 0x0, size 0x4
    class xBase* base_widge; // offset 0x4, size 0x4
    class zNPCCommon* npc_ownerlock; // offset 0x8, size 0x4
    void Reset();
};
```

When we save this and look at Objdiff now, we finally have no more error messages.
Not only that, but now the function is a 100% match!

#image("nothing/OK.png")

We've done it!
We have successfully decompiled our first function in Battle For Bikini Bottom.
It's a humble little function, but we should be proud nonetheless.

Throughout this process, we have learned quite a few things:

+ How to use Objdiff to view and compare assembly code
+ What our first assembly instruction `blr` means and why it is generated
+ How to copy over the correct class and enum types from the PS2 DWARF data
+ How to define a new class member function

This all might have seemed like a lot of work just to decompile a function
that does literally nothing.

At this point you may have a few questions, such as

1. Is it always this much trouble to simply get a function that does nothing to compile?

The answer to this is that it depends.
It depends largely on the function that you're decompiling and a combination of factors.
If the function is a member of a class, and that class is not defined in a header file
yet, then you will have to define it like we did in this example.
In this case, we also had to recursively define the properties which were included
in the class we added.
You can imagine that in some cases this could become a bit of work.

The same idea also applies for functions that do nothing but accept parameters
who's types are not defined yet.
Consider this example:
```cpp
void xDebugAddTweak(const char*, xVec3*, const tweak_callback*, void*, U32)
{
}
```
This function accepts types such as `xVec3*`, and `tweak_callback*` which are non-primitive types.
We already have these types included in the project header files,
so solving the type errors would be as simple as including the appropriate headers:
```cpp
#include "xVec3.h"
#include "zFX.h"
```
If we didn't already have those types defined in those header files,
you would have to copy the types for these parameters from
the PS2 DWARF again.
This is needed to get the file to compile
despite the fact that the function itself does nothing.

Then of course there are functions like `NPCWidget_Shutdown`
which are not part of a class nor accept any parameters,
so decompiling them is as simple as just writing:

```cpp
void NPCWidget_Shutdown()
{
}
```

And that's that.

2. Why are functions that do nothing even in the game?

This is a commonly asked question for a good reason and there are multiple answers.

A common reason might be that the original game code
had certain debugging code that might have been stripped out
during the release build.
There are at least 35 empty functions that contain the word "debug" that do nothing.
`zNPCBPlankton::render_debug()` for example.
You can imagine that the actual source code for this probably looked something like this:
```cpp
void zNPCBPlankton::render_debug()
{
    #ifdef DEBUG
    // ...
    // A bunch of code to debug the plankton boss...
    // ...
    #endif
}
```
Naturally when releasing, none of that code would have been included,
leaving us with empty functions.
These functions are still included in the game
and not optimized out by the compiler despite being empty in this case
because they are called from other areas of the code.
The compiler isn't smart enough to know that the function call itself
wouldn't create side effects, so it keeps the function in the game
despite it doing nothing in a release build.

Whew. This was a longer chapter than anticipated,
but we have learned quite a lot.
Whenever you're ready let's head on to the next example
and start decompiling functions that have
some actual code in them.
