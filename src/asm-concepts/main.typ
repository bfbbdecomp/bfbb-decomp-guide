= Assembly Concepts

== Program Segments
A code segment (and its companion, the data segment) is how a compiler and linker organize a program's contents into named regions. 
.text holds executable instructions, .rodata holds immutable constants like string literals, .data holds initialized writable globals, 
and .bss/.comm reserve space for uninitialized globals without storing bytes in the object file. 

Special small-data sections (.sdata, .sbss, .sdata2, .sbss2) group frequently accessed or size‑limited globals to enable more 
efficient addressing on some ABIs (for example, keeping them within a 16‑bit offset of a base register). 

These sections let the linker combine object files, resolve symbol addresses, and produce an executable image with
correct memory layout and access permissions, which the loader then maps into memory at runtime.

What follows is a dedicated description of each type of program segment we will encounter in a program
compiled to target the PowerPC EABI architecture.

=== .comm (Common)
Contains uninitialized global variables. These symbols are shared across object files during linking.

=== .bss (Block Started By Symbol)
Contains uninitialized static variables and global variables. Takes no space in the object file but reserves space in memory when loaded.

=== .ctors ("Constructors")
Contains "constructor" function pointers that are executed before main(). Used for global object initialization in C++.
Note that these functions are *not* class/struct constructors, but are simply functions called prior to the program entry point being called,
which is typically the first function that is called.

=== .data
Contains initialized static and global variables that can be modified during program execution.

=== .rodata (Read-Only Data)
Contains constant values like string literals and const variables that shouldn't be modified during execution.

=== .sbss (Small BSS)
Contains uninitialized static/global variables that are 8 bytes or smaller.

=== .sbss2 (Small BSS 2)
Contains static/global variables of size 8 bytes or smaller which are initialized to zero.

=== .sdata (Small Data)
Contains initialized static/global variables of size 8 bytes or smaller. .sdata will contain values that are explicitly non-zero.

=== .sdata2
Contains initialized static/global variables of size 8 bytes or smaller optimized for read-only access, although it can contain writablev values.

=== .text
Contains the actual executable code (machine instructions) of the program. This section is typically read-only to prevent code modification during execution.