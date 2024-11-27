# ICS3203-CAT2-Assembly-Estifanos_Gebremedin-148905

## Task 1: Number Check

This assembly program checks whether a number entered by the user is positive, negative, or zero. The program reads input from the user, converts it to an integer, and then displays the appropriate message based on the value of the number.

### Program Overview

#### Purpose:
- The program prompts the user to enter a number.
- It reads the number from the input, converts it to an integer, and compares it to zero.
- Depending on the result of the comparison, the program will print one of the following:
  - "The number is POSITIVE."
  - "The number is NEGATIVE."
  - "The number is ZERO."
- The program then exits.

#### Sections of the Program:
- **.data Section**: Contains constant data such as the prompt message and the strings for "POSITIVE", "NEGATIVE", and "ZERO".
- **.bss Section**: Reserves space for uninitialized data (in this case, the input number).
- **.text Section**: Contains the logic to interact with the user, process the input, and display the result.

#### Key System Calls:
- **sys_write (rax = 1)**: Used to print messages to standard output.
- **sys_read (rax = 0)**: Used to read input from the user.
- **sys_exit (rax = 60)**: Used to terminate the program.

#### Core Logic:
1. The program begins execution at the `_start` label.
2. It writes the prompt message asking the user to input a number.
3. It reads the user input and passes it to the `string_to_int` function to convert the string into an integer.
4. The integer is compared with zero:
   - If the number is positive, it jumps to the `is_positive` section and prints "The number is POSITIVE."
   - If the number is negative, it jumps to the `is_negative` section and prints "The number is NEGATIVE."
   - If the number is zero, it jumps to the `is_zero` section and prints "The number is ZERO."
5. The program terminates using the `sys_exit` system call.
##### Impact of each jump instruction
The program uses several jump instructions to control the flow based on the value of the input:
`cmp rbx, 0`: Compares the value in rbx (the integer value) with zero. This sets the processor's flags for subsequent jump instructions.
`je is_zero`: The je (jump if equal) instruction checks if the number is equal to zero. If true, it jumps to the is_zero label and prints "The number is ZERO." Ensures that when the number is zero, the program prints the correct message and exits.
`jl is_negative`: The jl (jump if less) instruction checks if the number is negative (i.e., less than zero). If true, it jumps to the is_negative label and prints "The number is NEGATIVE." Ensures that when the number is negative, the program prints the correct message and exits.
`jmp is_positive`: The jmp instruction is used here to unconditionally jump to the is_positive label. This happens if the number is positive (greater than zero), and the program prints "The number is POSITIVE." Ensures that when the number is positive, the program prints the correct message and exits.


### Compiling and Running the Program

To compile and run this program, follow these steps:

1. **Save the Code**:
   Save the assembly code in a file named `task1.asm`.

2. **Assemble and Link**:
   - Use `nasm` to assemble the code:
     ```bash
     nasm -f elf64 -o task1.asm task1.o
     ```
   - Use `ld` to link the object file and create the executable:
     ```bash
     ld task1.o -o task1
     ```

3. **Run the Program**:
   - Execute the program with:
     ```bash
     ./task1
     ```
   - The program will display the prompt, and you can enter a number. It will then print whether the number is positive, negative, or zero.

4. **Example Run**:
   ```bash
   Enter a number: 5
   The number is POSITIVE.
### Challenges
String to Integer Conversion: Converting the input string to an integer manually in assembly is complex. Each character in the string must be processed and converted from its ASCII representation to a numeric value, which was done using the `string_to_int` function.

## Task 2: 
