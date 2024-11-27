section .data
    msg_positive db "The number is POSITIVE.", 0
    msg_negative db "The number is NEGATIVE.", 0
    msg_zero db "The number is ZERO.", 0
    prompt db "Enter a number: ", 0
    newline db 0xA, 0

section .bss
    num resb 4

section .text
    global _start

_start:
    ;prompt for user input
    mov rax, 1          ; sys_write
    mov rdi, 1          ; stdout
    mov rsi, prompt     ; Address of the prompt
    mov rdx, 16         ; Length of the prompt
    syscall

    ;Read input
    mov rax, 0          ; sys_read
    mov rdi, 0          ; stdin
    mov rsi, num        ; Buffer for input
    mov rdx, 4          ; Read up to 4 bytes
    syscall

    ; Convert input to integer
    mov rsi, num        ; Address of input
    call string_to_int      
    mov rbx, rax        ; Store the number in rbx

    ;Compare the number
    cmp rbx, 0          ; Compare the number with 0
    je is_zero          ; Jump if the number is zero
    jl is_negative      ; Jump if the number is less than zero
    jmp is_positive     ; Unconditional jump for positive

is_positive:
    ; print "POSITIVE"
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_positive
    mov rdx, 23
    syscall
    jmp done

is_negative:
    ; Print "NEGATIVE"
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_negative
    mov rdx, 23
    syscall
    jmp done

is_zero:
    ; Print "ZERO"
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_zero
    mov rdx, 19
    syscall

done:
    ; Exit program
    mov rax, 60
    xor rdi, rdi
    syscall

; Converts a string to integer
string_to_int:
    xor rax, rax            ; Clear rax (result)
    xor rcx, rcx            ; Clear rdi (multiplier)

convert_loop:
    movzx rcx, byte [rsi]   ;Load a byte from the string
    cmp rcx, 0xA            ; Check for newline
    je end_convert
    cmp rcx, 0
    je end_convert
    sub rcx, '0'            ; Convert ASCII to digit
    imul rax, rax, 10       ; Multiply previous result by 10
    add rax, rcx            ; Add the digit
    inc rsi                 ; Move to the next character
    jmp convert_loop

end_convert:
    ret