section .data
demo1: dq 0x1122334455667788
demo2: db 0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77, 0x88
demo3: dw 0x1234

section .text
extern print_hex
extern print_newline
global _start

_start:
    mov rdi, [demo1]
    call print_hex
    call print_newline

    mov rdi, [demo2]
    call print_hex
    call print_newline

    mov rdi, [demo3]
    call print_hex
    call print_newline

    mov rax, 60
    xor rdi, rdi
    syscall
