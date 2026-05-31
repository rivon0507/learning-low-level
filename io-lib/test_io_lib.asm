global _start
extern print_char
extern print_newline
extern print_string
extern exit
extern print_uint
extern print_int
extern read_char
extern read_word

section .data
hello: db 'Hello, world!', 0

section .text

_start:
    mov rdi, hello
    call print_string
    call print_newline
    mov rdi, [hello + 0x2]
    call print_char
    call print_newline
    mov qword rdi, 123488
    call print_uint
    call print_newline
    mov qword rdi, -123488
    call print_uint
    call print_newline
    mov qword rdi, -123488
    call print_int
    call print_newline
    call read_char
    mov rdi, rax
    call print_uint
    call print_newline

    push rbp
    mov rbp, rsp
    sub rsp, 0x20
    lea rdi, [rsp]
    mov rsi, 0xa
    call read_word
    mov rdi, rax
    call print_string
    call print_newline
    mov rsp, rbp
    pop rbp
    mov rdi, 0
    call exit
