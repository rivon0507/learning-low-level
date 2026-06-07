global exit
global string_length
global print_char
global print_newline
global print_string
global print_uint
global print_int
global read_char
global read_word
global parse_uint
global parse_int

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
    xor rbx, rbx
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
    push r12
    push r13
    xor rbx, rbx
    mov r12, rdi
    mov r13, rsi

    mov rdx, rsi
    mov rsi, rdi
    mov rdi, 0
    mov rax, 0
    syscall
    cmp rax, 0x0
    jl .read_error
    add rbx, rax
    xor rcx, rcx
.find_offset_loop:
    cmp rcx, rax
    jge .all_whitespace
    mov dil, [r12 + rcx]
    call test_whitespace
    jne .found_offset
    inc rcx
    jmp .find_offset_loop
.all_whitespace:
    xor rbx, rbx
    jmp .no_more_offset
.found_offset:
    test rcx, rcx
    jz .epilogue
    mov rdx, rcx
    sub rbx, rcx
    lea rsi, [r12 + rdx]
    xor rcx, rcx
.trim_left:
    cmp rcx, rbx
    jge .no_more_offset
    mov dil, byte [rsi + rcx]
    mov [r12 + rcx], dil
    inc rcx
    jmp .trim_left
.no_more_offset:
    mov rax, 0
    mov rdi, 0
    lea rsi, [r12 + rbx]
    mov rdx, r13
    sub rdx, rbx
    syscall
    cmp rax, 0x0
    jl .read_error
    add rbx, rax
.epilogue:
    xor rcx, rcx
.find_null_location:
    cmp rcx, r13
    jge .not_fitting
    cmp rcx, rbx
    jge .add_null_term
    mov dil, [r12 + rcx]
    call test_whitespace
    je .add_null_term
    inc rcx
    jmp .find_null_location
.add_null_term:
    mov byte [r12 + rcx], 0x0
    mov rax, r12
    jmp .end
.read_error:
.not_fitting:
    mov rax, 0
.end:
    pop r13
    pop r12
    pop rbx
    ret

parse_uint:
    ; rdi: null-terminated string to parse an uint from
    ; rbx: parsed number
    ; rax: parsed characters count
    push rbx
    mov rbx, 0xa
    xor rcx, rcx
    xor rax, rax
    xor rsi, rsi
.parse_char:
    mov sil, byte [rdi + rcx]
    sub sil, 0x30
    cmp sil, 0x0
    jl .end_of_number
    cmp sil, 0x9
    jg .end_of_number
    mul rbx
    add rax, rsi
    inc rcx
    jmp .parse_char
.end_of_number:
    mov rdx, rcx
    pop rbx
    ret

parse_int:
    ; rdi: null-terminated string to parse an int from
    ; rbx: parsed number
    ; rax: parsed characters count
    ; rbx: the sign, 0 for positive, 1 for negative
    push rbx
    push rdi
    xor rbx, rbx
    cmp byte [rdi], 0x2d
    jne .positive
    mov rbx, 0x1
    lea rdi, [rdi + 1]
.positive:
    call parse_uint
    test rbx, rbx
    jz .end ; skip signing
    neg rax
.end:
    pop rdi
    pop rbx
    ret

