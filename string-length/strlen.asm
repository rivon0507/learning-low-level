global _start

section .data
test_string: db 'abcdef', 0

section .text

strlen:
    xor rax, rax
.loop:
    cmp byte [rdi + rax], 0
    je .exit
    inc rax
    jmp .loop
.exit:
    ret

_start:
    lea rdi, [test_string]
    call strlen
    mov rdi, rax
    mov rax, 60
    syscall
