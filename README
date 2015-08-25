### NASM libC.

To become familiar with NASM, I decided to write some of the C library functions in assembly.

The `lib.c` file shows how to use each function (most examples come from the C man pages).

#### How to compile :

```
nasm -f elf lib.asm 
nasm -f elf64 lib.asm  # For x86_64 
```

This command will create a `lib.o` file which is required by the `lib.c` (or any applications other applications that wishes to use this library).

Then compile your file with `gcc` and run it :

```
gcc lib.c lib.o -o lib
./lib
``` 

Enjoy
