section .data
    prompt db "Enter a number (0-9): ", 0
    result_msg db "Factorial is: ", 0
    newline db 10

section .bss
    input resb 10
    result resd 1

section .text
    global _start

_start:
    ; Prompt
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt
    mov edx, 21
    int 0x80

    ; Read input
    mov eax, 3
    mov ebx, 0
    mov ecx, input
    mov edx, 5
    int 0x80

    ; Convert input to number
    movzx eax, byte [input]
    sub eax, '0'

    ; Calculate factorial
    mov ebx, eax
    call factorial

    ; Print result message
    mov eax, 4
    mov ebx, 1
    mov ecx, result_msg
    mov edx, 14
    int 0x80

    ; Print factorial
    mov eax, [result]
    call print_number

    ; Exit
    mov eax, 1
    xor ebx, ebx
    int 0x80

; Factorial calculation
factorial:
    ; Start with 1 in result
    mov dword [result], 1
    
    ; Skip if input is 0 or 1
    cmp ebx, 1
    jle factorial_done

factorial_loop:
    ; Multiply current result by current number
    mov eax, [result]
    mul ebx
    mov [result], eax
    
    ; Decrement and continue if > 1
    dec ebx
    cmp ebx, 1
    jg factorial_loop

factorial_done:
    ret

; Print number routine
print_number:
    ; Prepare buffer for digit conversion
    mov ecx, 10
    mov edi, input + 9  ; End of buffer
    mov byte [edi], 0   ; Null terminator

convert_loop:
    xor edx, edx
    div ecx
    add dl, '0'
    dec edi
    mov byte [edi], dl
    test eax, eax
    jnz convert_loop

    ; Print converted number
    mov eax, 4
    mov ebx, 1
    mov ecx, edi
    mov edx, input + 9
    sub edx, edi
    int 0x80

    ; Print newline
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    ret