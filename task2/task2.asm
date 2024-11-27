section .data
    prompt db "Enter 5 integers (space-separated): ", 0   ; Prompt message for user input
    result_msg db "Reversed array: ", 0                    ; Message displayed before printing reversed array
    space db " ", 0                                        ; Space character for separating printed integers
    newline db 10, 0                                       ; Newline character (ASCII value 10) for line breaks

section .bss
    array resd 5             ; Reserve 5 DWORDs (4 bytes each) for the array to hold 5 integers
    num resb 4               ; Reserve 4 bytes for temporary storage of one character at a time

section .text
    global _start           ; Define the entry point of the program

_start:
    ; Print prompt to ask the user for input
    mov eax, 4              ; syscall number 4 (sys_write) for printing output
    mov ebx, 1              ; File descriptor 1 (stdout)
    mov ecx, prompt         ; Address of the prompt string
    mov edx, 35             ; Length of the prompt string
    int 0x80                ; Call kernel to print the prompt

    ; Read 5 integers from the user
    xor edi, edi            ; Clear edi register (index counter for the array)
input_loop:
    cmp edi, 5              ; Check if we have already read 5 integers
    je read_done            ; If yes, jump to the read_done label
    
    ; Read a single character from stdin
    mov eax, 3              ; syscall number 3 (sys_read) for reading input
    mov ebx, 0              ; File descriptor 0 (stdin)
    mov ecx, num            ; Address of the buffer to store the input character
    mov edx, 1              ; Read 1 byte (1 character)
    int 0x80                ; Call kernel to read input character

    ; Skip spaces and newlines in the input
    cmp byte [num], ' '     ; If the character is a space, continue to next character
    je input_loop
    cmp byte [num], 10      ; If the character is a newline (ASCII 10), continue to next character
    je input_loop

    ; Convert the character to a number and store it in the array
    movzx eax, byte [num]   ; Move the byte (character) into eax and zero-extend
    sub eax, '0'            ; Convert ASCII character to integer (subtract '0')
    mov [array + edi*4], eax ; Store the number at the correct position in the array
    inc edi                 ; Increment the index (edi)
    jmp input_loop          ; Loop to read the next character

read_done:
    ; Reverse the array
    mov esi, 0              ; Start index (esi) for the array
    mov edi, 4              ; End index (edi) for the array (5 elements - 1)

reverse_loop:
    cmp esi, edi            ; Check if start index (esi) is greater than or equal to end index (edi)
    jge print_results       ; If indices have crossed, jump to print_results

    ; Swap the elements at indices esi and edi
    mov eax, [array + esi*4]     ; Load the element at the start index into eax
    mov ebx, [array + edi*4]     ; Load the element at the end index into ebx
    mov [array + esi*4], ebx     ; Store the element at the start index as the end element
    mov [array + edi*4], eax     ; Store the element at the end index as the start element

    inc esi                      ; Move start index forward
    dec edi                      ; Move end index backward
    jmp reverse_loop             ; Repeat the loop

print_results:
    ; Print result message "Reversed array: "
    mov eax, 4              ; syscall number 4 (sys_write) for printing output
    mov ebx, 1              ; File descriptor 1 (stdout)
    mov ecx, result_msg     ; Address of the result message string
    mov edx, 17             ; Length of the result message string
    int 0x80                ; Call kernel to print the result message

    ; Print the reversed array
    xor esi, esi                 ; Clear esi register (index counter for printing)
print_loop:
    cmp esi, 5                   ; Check if we have printed all 5 integers
    je exit_program              ; If yes, jump to exit_program

    ; Convert the integer to an ASCII character
    mov eax, [array + esi*4]     ; Load the current array element into eax
    add eax, '0'                 ; Convert the number to its ASCII equivalent (add '0')
    mov [num], al                ; Store the ASCII character in the num buffer

    ; Print the current number
    mov eax, 4              ; syscall number 4 (sys_write) for printing output
    mov ebx, 1              ; File descriptor 1 (stdout)
    mov ecx, num            ; Address of the number's ASCII representation
    mov edx, 1              ; Print 1 byte (1 character)
    int 0x80                ; Call kernel to print the number

    ; Print a space after the number
    mov eax, 4              ; syscall number 4 (sys_write) for printing output
    mov ebx, 1              ; File descriptor 1 (stdout)
    mov ecx, space          ; Address of the space character
    mov edx, 1              ; Print 1 byte (1 space)
    int 0x80                ; Call kernel to print the space

    inc esi                 ; Increment the index (esi)
    jmp print_loop          ; Repeat the loop

exit_program:
    ; Print newline to finish the output
    mov eax, 4              ; syscall number 4 (sys_write) for printing output
    mov ebx, 1              ; File descriptor 1 (stdout)
    mov ecx, newline        ; Address of the newline character
    mov edx, 1              ; Print 1 byte (1 newline)
    int 0x80                ; Call kernel to print the newline

    ; Exit the program
    mov eax, 1              ; syscall number 1 (sys_exit) to exit the program
    xor ebx, ebx            ; Return code 0 (success)
    int 0x80                ; Call kernel to exit
