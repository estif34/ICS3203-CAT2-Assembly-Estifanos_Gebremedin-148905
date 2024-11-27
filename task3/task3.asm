section .data
    prompt db "Enter a number (0-9): ", 0  ; Prompt message for user input
    result_msg db "Factorial is: ", 0       ; Message to display before the result
    newline db 10                           ; Newline character for formatting output

section .bss
    input resb 10                           ; Reserve 10 bytes for user input (maximum of 9 digits + null terminator)
    result resd 1                           ; Reserve 4 bytes for storing the factorial result

section .text
    global _start                           ; Entry point for the program

_start:
    ; Prompt the user for input
    mov eax, 4                              ; syscall number for sys_write (output)
    mov ebx, 1                              ; file descriptor for standard output (stdout)
    mov ecx, prompt                         ; address of the prompt string
    mov edx, 21                             ; length of the prompt string
    int 0x80                                 ; make the syscall (print prompt)

    ; Read the user's input
    mov eax, 3                              ; syscall number for sys_read (input)
    mov ebx, 0                              ; file descriptor for standard input (stdin)
    mov ecx, input                          ; address to store the input
    mov edx, 5                              ; number of bytes to read (max 5 characters for the input)
    int 0x80                                 ; make the syscall (read input)

    ; Convert the ASCII input to a number
    movzx eax, byte [input]                 ; Load the first byte of input (input is a string)
    sub eax, '0'                             ; Convert ASCII character to integer (subtract ASCII value of '0')

    ; Store the input number in ebx for factorial calculation
    mov ebx, eax                            ; Move the number into ebx for the factorial calculation
    call factorial                          ; Call the factorial function

    ; Print the result message
    mov eax, 4                              ; syscall number for sys_write (output)
    mov ebx, 1                              ; file descriptor for standard output (stdout)
    mov ecx, result_msg                     ; address of the result message
    mov edx, 14                             ; length of the result message string
    int 0x80                                 ; make the syscall (print result message)

    ; Print the calculated factorial
    mov eax, [result]                       ; Load the factorial result from memory
    call print_number                       ; Call print_number function to print the result

    ; Exit the program
    mov eax, 1                              ; syscall number for sys_exit (exit the program)
    xor ebx, ebx                            ; exit status 0
    int 0x80                                 ; make the syscall (exit the program)

; Factorial calculation function
factorial:
    ; Initialize the result to 1 (factorial base case)
    mov dword [result], 1                   ; Set the result to 1
    
    ; Check if input number is 0 or 1, if so factorial is 1
    cmp ebx, 1                              ; Compare input (in ebx) with 1
    jle factorial_done                      ; If less than or equal to 1, jump to factorial_done

factorial_loop:
    ; Multiply the result by the current number (ebx)
    mov eax, [result]                       ; Load current result into eax
    mul ebx                                  ; Multiply eax by ebx (eax = eax * ebx)
    mov [result], eax                       ; Store the result back into 'result'

    ; Decrement the value in ebx and check if it is still greater than 1
    dec ebx                                  ; Decrement the number (ebx)
    cmp ebx, 1                               ; Compare ebx with 1
    jg factorial_loop                        ; If greater than 1, loop again

factorial_done:
    ret                                      ; Return from the factorial function

; Print number function (converts a number to a string and prints it)
print_number:
    ; Prepare to convert the number in eax to a string
    mov ecx, 10                             ; Set divisor to 10 for number to string conversion (decimal system)
    mov edi, input + 9                      ; Point edi to the end of the input buffer (reserve space for string)
    mov byte [edi], 0                       ; Null terminate the string (ASCII 0)

convert_loop:
    xor edx, edx                             ; Clear edx (remainder of division)
    div ecx                                   ; Divide eax by 10, result in eax, remainder in edx
    add dl, '0'                               ; Convert remainder (digit) to ASCII character by adding '0'
    dec edi                                    ; Move the buffer pointer backward (store digits from right to left)
    mov byte [edi], dl                        ; Store the digit as a character in the buffer

    test eax, eax                             ; Test if eax is 0 (check if division is complete)
    jnz convert_loop                         ; If eax is not 0, continue converting

    ; Print the converted number (string)
    mov eax, 4                                ; syscall number for sys_write (output)
    mov ebx, 1                                ; file descriptor for standard output (stdout)
    mov ecx, edi                              ; pointer to the number string
    mov edx, input + 9                        ; length of the number string (null-terminated)
    sub edx, edi                               ; calculate the length of the string
    int 0x80                                   ; make the syscall (print number)

    ; Print a newline character for formatting
    mov eax, 4                                ; syscall number for sys_write (output)
    mov ebx, 1                                ; file descriptor for standard output (stdout)
    mov ecx, newline                          ; pointer to newline character
    mov edx, 1                                 ; length of newline
    int 0x80                                    ; make the syscall (print newline)

    ret                                         ; Return from the print_number function
