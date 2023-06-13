global _start

section     .text
extern atoi
extern printf
          
print_new_line:
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall
    ret

print_data:
    push    rbp                      ; save old base pointer
    mov     rbp, rsp                  ; use current stack pointer as new base pointer
    mov     rax, SYS_write                  ; system call for write
    mov     rdi, STDOUT                  ; file handle 1 is stdout
    mov     rsi, [rbp + 24]          ; address of string to output
    mov     rdx, [rbp + 16]          ; number of bytes
    syscall                         ; invoke operating system to do the write
    call    print_new_line       
    pop     rbp      
    ret     

read_from_keyboard:
    pop     rbx
    mov     rax, SYS_read             ; set SYS_READ as SYS_CALL value
    sub     rsp, 8                  ; allocate 8-byte space on the stack as read buffer
    mov     rdi, STDIN                  ; set rdi to 0 to indicate a STDIN file descriptor
    lea     rsi, [rsp]              ; set const char *buf to the 8-byte space on stack
    mov     rdx, 12                 ; set size_t count to 1 for one char
    syscall
    push    rbx
    ret

_start:   

    push digite_numero
    push digite_numero_len
    call print_data

    call read_from_keyboard
    mov rdi, rsp
    call atoi
    mov [num1], rax

    push digite_operador
    push digite_operador_len
    call print_data

    call read_from_keyboard
    mov [operador], rsp

    push digite_numero
    push digite_numero_len
    call print_data

    call read_from_keyboard
    mov rdi, rsp
    call atoi
    mov [num2], rax

    mov rax, qword [num1]
    add rax, qword [num2]
    mov qword [result], rax

    pop rcx ; pilha ta zoada, tem que dar esse pop senao quebra tudo
    mov rdi, result_msg
    mov rsi, [result]
    xor rax, rax
    call printf
    push rcx
    
    mov       rax, 60                 ; system call for exit
    xor       rdi, rdi                ; exit code 0
    syscall                           ; invoke operating system to exit

section     .data

    digite_numero:        db      "Por favor, digite um numero: "
    digite_numero_len:    equ     $-digite_numero

    digite_operador: db "Por favor, digite um operador (+ - * /): "
    digite_operador_len: equ $-digite_operador

    result_msg: db "O resultado é: %d", 10
    newline:        db      0xA
    STDIN:          equ     0 ; standard input
    STDOUT:         equ     1 ; standard output
    SYS_read:       equ     0 ; read
    SYS_write:      equ     1 ; write

section     .bss

    num1: resq 1
    num2: resq 1
    operador: resq 32
    result: resq 2