bits 64

global _start

BUFFER_SIZE equ 256

section .data
buffer:
times BUFFER_SIZE db 0

section .text
_start:
mov rax, [rsp]
dec rax
je do_stdin
call _exit


do_stdin:
.entry:
mov rsi, buffer
mov rdx, BUFFER_SIZE
call read
test rax, rax
je .exit
mov rsi, buffer
mov rdx, rax
call write
jmp .entry
.exit:
call _exit

strlen:
push rcx
xor rax, rax
.loop:
mov cl, [rdi]
test cl, cl
je .end
inc rdi
inc rax
jmp .loop
.end:
pop rcx
ret

; Reads from standard input
; rsi must be pointer to the buffer
; rdx should be count of bytes to be read
read:
mov rax, 0 ; syscall number for SYS_read
mov rdi, 0 ; 0 -> fd for stdin
syscall
ret

; Writes to standard output
; rsi must be pointer to the buffer
; rdx should be count of bytes to be written
write:
mov rax, 1 ; syscall number for SYS_write
mov rdi, 1 ; 1 -> fd for stdout
syscall
ret

; Exit successfully
_exit:
mov rax, 60
mov rdi, 0
syscall
ret


