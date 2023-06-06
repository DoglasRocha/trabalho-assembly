global _start

section     .text
          
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
    mov     rax, 1                  ; system call for write
    mov     rdi, 1                  ; file handle 1 is stdout
    mov     rsi, [rbp + 24]          ; address of string to output
    mov     rdx, [rbp + 16]          ; number of bytes
    syscall                         ; invoke operating system to do the write
    call print_new_line       
    pop     rbp      
    ret     

read_from_keyboard:
    mov     rax, 0                  ; set SYS_READ as SYS_CALL value
    sub     rsp, 8                  ; allocate 8-byte space on the stack as read buffer
    mov     rdi, 0                  ; set rdi to 0 to indicate a STDIN file descriptor
    lea     rsi, [rsp]        ; set const char *buf to the 8-byte space on stack
    mov     rdx, 8                 ; set size_t count to 1 for one char
    syscall
    ret

_start:   
    ;call        read_from_keyboard
    mov     rax, 0                  ; set SYS_READ as SYS_CALL value
    sub     rsp, 8                  ; allocate 8-byte space on the stack as read buffer
    mov     rdi, 0                  ; set rdi to 0 to indicate a STDIN file descriptor
    lea     rsi, [aaa]        ; set const char *buf to the 8-byte space on stack
    mov     rdx, 12                 ; set size_t count to 1 for one char
    syscall
    
    push        message
    push        message_len
    call        print_data
    
    ;mov       rax, 1                  ; system call for write
    ;mov       rdi, 1                  ; file handle 1 is stdout
    ;mov       rsi, message            ; address of string to output
    ;mov       rdx, 13                 ; number of bytes
    ;syscall
    
    mov       rax, 60                 ; system call for exit
    xor       rdi, rdi                ; exit code 0
    syscall                           ; invoke operating system to exit

section     .data

message: db     "Hello, World", 10      ; note the newline at the end
message_len: equ $-message
newline: db     0xA

section     .bss

aaa: resb 15