global _start
extern print_char
extern print_newline
extern print_string
extern exit
extern print_uint
extern print_int
extern read_char
extern read_word
extern parse_uint
extern parse_int

section .data
hello: db "Hello, world!", 0
t_print_char: db "[print_char]", 0xa, 0
t_print_uint: db "[print_uint]", 0xa, 0
t_print_int: db "[print_int]", 0xa, 0
t_read_char: db "[read_char] Enter a character>", 0
t_ascii_of_your_char: db "Ascii of your char: ", 0 
t_enter_a_word: db "[Enter a word]>", 0
t_no_word_read: db "[NO WORD READ]", 0xa, 0
t_your_number_is: db "[Your number is] ", 0
t_parsed_chars: db " [Parsed chars] ", 0
t_your_word_is: db "[Your word is] ", 0
t_enter_a_number: db "[Enter a number]>", 0 
t_enter_a_positive_number: db "[Enter a positive number]>", 0 

section .text

_start:
    push rbx
    push r12
    lea rdi, [rel hello]
    call print_string ; Hello, world!
    call print_newline
    lea rdi, [rel t_print_char]
    call print_string ; [print_char]
    mov rdi, [rel hello + 0x2]
    call print_char ; H
    call print_newline
    lea rdi, [rel t_print_uint]
    call print_string ; [print_uint]
    mov qword rdi, 123488
    call print_uint
    call print_newline
    lea rdi, [rel t_print_uint]
    call print_string ; [print_uint] 
    mov qword rdi, -123488
    call print_uint
    call print_newline
    lea rdi, [rel t_print_int]
    call print_string ; [print_int] 
    mov qword rdi, -123488
    call print_int
    call print_newline
    lea rdi, [rel t_read_char]
    call print_string ; [read_char] Enter a character: 
    call read_char
    mov rbx, rax
    lea rdi, [rel t_ascii_of_your_char]
    call print_string ; Ascii of your char:  
    mov rdi, rbx
    call print_uint
    call print_newline

    push rbp
    mov rbp, rsp
    sub rsp, 0x20
    lea rdi, [rel t_enter_a_word]
    call print_string ; [Enter a word] 
    lea rdi, [rsp]
    mov rsi, 0xa
    call read_word
    test rax, rax
    jz .no_word_read
    mov rbx, rax
    lea rdi, [rel t_your_word_is]
    call print_string ; Your word is:  
    mov rdi, rbx
    call print_string 
    call print_newline
    jmp .read_uint
.no_word_read:
    lea rdi, [rel t_no_word_read]
    call print_string ; [NO WORD READ]
.read_uint:
    lea rdi, [rel t_enter_a_positive_number]
    call print_string ; [Enter a positive number] 
    lea rdi, [rsp]
    mov rsi, 0x10
    call read_word
    test rax, rax
    jz .no_word_read_2
    mov rdi, rax
    call parse_uint
    mov rbx, rax
    mov r12, rdx
    lea rdi, [rel t_your_number_is]
    call print_string ; [Your number is] 
    mov rdi, rbx
    call print_uint
    lea rdi, [rel t_parsed_chars] ;  [Parsed chars] 
    call print_string
    mov rdi, r12
    call print_uint
    call print_newline
    jmp .read_int
.no_word_read_2:
    lea rdi, [rel t_no_word_read]
    call print_string ; [NO WORD READ]
.read_int:
    lea rdi, [rel t_enter_a_number]
    call print_string ; [Enter a number] 
    lea rdi, [rsp]
    mov rsi, 0x10
    call read_word
    test rax, rax
    jz .no_word_read_3
    mov rdi, rax
    call parse_int
    mov rbx, rax
    mov r12, rdx
    lea rdi, [rel t_your_number_is]
    call print_string ; [Your number is] 
    mov rdi, rbx
    call print_int
    lea rdi, [rel t_parsed_chars] ;  [Parsed chars] 
    call print_string
    mov rdi, r12
    call print_uint
    call print_newline
    jmp .end
.no_word_read_3:
    lea rdi, [rel t_no_word_read]
    call print_string ; [NO WORD READ]
.end:
    mov rsp, rbp
    pop rbp
    pop r12
    pop rbx
    mov rdi, 0
    call exit
