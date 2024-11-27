section .data
    prompt db "Enter a sensor value (0-3): ", 0       ; Prompt message
    motor_on_msg db "Motor ON", 0                       ; Motor on message
    motor_off_msg db "Motor OFF", 0                     ; Motor off message
    alarm_on_msg db "ALARM TRIGGERED", 0                ; Alarm message
    sensor_value db 0                                  ; Simulated sensor value (0-3)

section .text
    global _start

_start:
    ; Print the prompt
    mov eax, 4            ; sys_write system call
    mov ebx, 1            ; File descriptor (stdout)
    mov ecx, prompt       ; Address of the prompt message
    mov edx, 29           ; Length of the prompt
    int 0x80

    ; Read the sensor value from input (simulate user input)
    mov eax, 3            ; sys_read system call
    mov ebx, 0            ; File descriptor (stdin)
    mov ecx, sensor_value ; Address of the sensor_value
    mov edx, 1            ; Number of bytes to read (1 byte for the value)
    int 0x80

    ; Convert ASCII input to integer
    mov al, [sensor_value]  ; Load the sensor value (in ASCII)
    sub al, '0'             ; Convert from ASCII to integer
    movzx eax, al           ; Zero-extend to 32-bit

    ; Perform actions based on sensor value
    cmp eax, 3              ; Check if the sensor value is 3
    je trigger_alarm        ; Jump to trigger_alarm if sensor value is 3
    cmp eax, 2              ; Check if the sensor value is 2
    je stop_motor           ; Jump to stop_motor if sensor value is 2
    cmp eax, 1              ; Check if the sensor value is 1
    je start_motor          ; Jump to start_motor if sensor value is 1
    jmp motor_off           ; Otherwise, turn the motor off

start_motor:
    ; Turn on the motor
    mov eax, 4             ; sys_write system call
    mov ebx, 1             ; File descriptor (stdout)
    mov ecx, motor_on_msg  ; Message to display
    mov edx, 9             ; Length of "Motor ON"
    int 0x80
    jmp exit_program       ; Exit the program

stop_motor:
    ; Turn off the motor
    mov eax, 4             ; sys_write system call
    mov ebx, 1             ; File descriptor (stdout)
    mov ecx, motor_off_msg ; Message to display
    mov edx, 10            ; Length of "Motor OFF"
    int 0x80
    jmp exit_program       ; Exit the program

trigger_alarm:
    ; Trigger the alarm
    mov eax, 4             ; sys_write system call
    mov ebx, 1             ; File descriptor (stdout)
    mov ecx, alarm_on_msg  ; Message to display
    mov edx, 16            ; Length of "ALARM TRIGGERED"
    int 0x80
    jmp exit_program       ; Exit the program

motor_off:
    ; Default action: turn off the motor
    mov eax, 4             ; sys_write system call
    mov ebx, 1             ; File descriptor (stdout)
    mov ecx, motor_off_msg ; Message to display
    mov edx, 10            ; Length of "Motor OFF"
    int 0x80
    jmp exit_program       ; Exit the program

exit_program:
    mov eax, 1             ; sys_exit system call
    xor ebx, ebx           ; Exit code 0
    int 0x80