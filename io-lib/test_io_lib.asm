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
extern string_equals
extern string_copy

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
t_guess_the_word: db "[Guess the word]>", 0
t_you_guessed_right: db "[You guessed right!]", 0xa, 0
t_you_guessed_wrong: db "[You guessed wrong!]", 0xa, 0
t_word_to_guess: db "supercalifragilistic", 0
t_choose_number_0_24: db "[Choose a number between 0 and 24]>", 0
t_number_lower_than_0: db "[THE NUMBER IS LOWER THAN 0]", 0xa, 0
t_number_higher_than_24: db "[THE NUMBER IS HIGHER THAN 24]", 0xa, 0
t_not_fitting: db "[NOT FITTING]", 0xa, 0

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
    jmp .end_read_int
.no_word_read_3:
    lea rdi, [rel t_no_word_read]
    call print_string ; [NO WORD READ]
.end_read_int:
    lea rdi, [rel t_guess_the_word]
    call print_string ; [Guess the word]>
    lea rdi, [rsp]
    mov rsi, 0x18
    call read_word
    lea rdi, [rel t_word_to_guess]
    mov rsi, rax
    call string_equals
    test rax, rax
    jz .different
    lea rdi, [rel t_you_guessed_right]
    call print_string
    jmp .end_guess_word
.different:
    lea rdi, [rel t_you_guessed_wrong]
    call print_string
.end_guess_word:
    lea rdi, [rel t_choose_number_0_24]
    call print_string
    lea rdi, [rsp]
    mov rsi, 0x18
    call read_word
    mov rdi, rax
    call parse_int
    cmp rax, 24
    jg .too_big
    cmp rax, 0
    jl .too_small
    mov rdx, rax
    lea rdi, [rel hello]
    lea rsi, [rsp]
    call string_copy
    test rax, rax
    jz .not_fitting
    mov rdi, rax
    call print_string
    jmp .end
.too_big:
    lea rdi, [rel t_number_higher_than_24]
    call print_string
    jmp .end
.too_small:
    lea rdi, [rel t_number_lower_than_0]
    call print_string
    jmp .end
.not_fitting:
    lea rdi, [rel t_not_fitting]
    call print_string
.end:
    mov rsp, rbp
    pop rbp
    pop r12
    pop rbx
    mov rdi, 0
    call exit
