global exit
global string_length
global print_char
global print_newline
global print_string
global print_uint
global print_int
global read_char
global read_word

section .text
exit:
    mov rax, 60
    syscall

string_length:
    xor rax, rax
.loop:
    cmp byte [rdi + rax], 0
    je .end
    inc rax
    jmp .loop
.end:
    ret

print_string:
    call string_length
    mov rdx, rax
    mov rsi, rdi
    mov rdi, 1
    mov rax, 1
    syscall
    ret

print_char:
    push rdi
    mov rdx, 1
    mov rsi, rsp
    mov rdi, 1
    mov rax, 1
    syscall
    pop rdi
    ret

print_newline:
    mov rdi, 10
    call print_char
    ret

print_uint:
    push rbp
    push rbx
    mov rbp, rsp
    sub rsp, 0x20
    and rbx, 0x1
    mov rax, rdi
    mov rcx, 0xa
    lea rsi, [rbp - 0x8]
.loop:
    xor rdx, rdx
    div rcx
    add rdx, 0x30
    dec rsi
    mov byte [rsi], dl
    inc rbx
    test rax, rax
    jnz .loop
    mov rax, 1
    mov rdi, 1
    mov rdx, rbx
    syscall
    mov rsp, rbp
    pop rbx
    pop rbp
    ret

print_int:
    cmp rdi, 0
    jge .positive
    push rdi
    mov rdi, 0x2d
    call print_char
    pop rdi
    neg rdi
.positive:
    call print_uint
    ret

read_char:
    push rbp
    mov rbp, rsp
    sub rsp, 0x10
    mov rax, 0
    mov rdi, 0
    lea rsi, [rbp - 0x8]
    mov rdx, 0x1
    syscall
    test rax, rax
    jz .handle_eof
    mov rax, [rbp - 0x8]
.handle_eof: ; rax is 0 from the syscall
    mov rsp, rbp
    pop rbp
    ret

test_whitespace:
    cmp dil, 0x20    ; Is it a space?
    je  .match
    cmp dil, 0x09    ; Is it a tab?
    je  .match
    cmp dil, 0x0A    ; Is it a newline?
.match:
    ret

read_word:
    push rbx
    xor rbx, rbx
    push rdi
    push rsi

    mov rdx, rsi
    mov rsi, rdi
    mov rdi, 0
    mov rax, 0
    syscall
    add rbx, rax

    pop rsi
    pop rdi
    xor rcx, rcx
.find_offset_loop:
    cmp rcx, rax
    jg .epilogue
    push rdi
    mov dil, [rdi + rcx]
    call test_whitespace
    pop rdi
    jne .found_offset
    inc rcx
    jmp .find_offset_loop
.found_offset:
    push rsi
    test rcx, rcx
    jz .no_offset
    mov rdx, rcx
    sub rbx, rcx
    xor rcx, rcx
.trim_left:
    add rdi, rdx
    mov sil, byte [rdi + rcx]
    sub rdi, rdx
    mov [rdi + rcx], sil
    inc rcx
    cmp rcx, rax
    jge .no_more_offset
    jmp .trim_left
.no_more_offset:
    pop rsi
    push rdi
    sub rsi, rax
    add rsi, rdx
    add rdi, rax
    sub rdi, rdx

    mov rdx, rsi
    mov rsi, rdi
    mov rdi, 0
    mov rax, 0
    syscall
    add rbx, rax

    pop rdi
    jmp .epilogue
.no_offset:
    pop rsi
.epilogue:
    xor rcx, rcx
    mov rdx, rdi
.find_null_location:
    cmp rcx, rsi
    jge .not_fitting
    cmp rcx, rbx
    jge .add_null_term
    mov rdi, [rdx + rcx]
    call test_whitespace
    je .add_null_term
    inc rcx
    jmp .find_null_location
.add_null_term:
    mov byte [rdx + rcx], 0x0
    mov rax, rdx
    jmp .end
.not_fitting:
    mov rax, 0
.end:
    pop rbx
    ret
