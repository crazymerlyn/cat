bits 64

global _start

BUFFER_SIZE equ 256

%define sys_read 0
%define sys_write 1

%define stdin 0
%define stdout 1

%define sys_exit 60
%define success 0

section .data
buffer:
times BUFFER_SIZE db 0

section .text
_start:
mov rax, [rsp]
dec rax
je .do_stdin
add rsp, 16
.loop_start:
mov rdi, [rsp]
test rdi, rdi
je .exit
xor rsi, rsi
xor rdx, rdx
mov rax, 2
syscall
mov rdi, rax
call do_read_write
add rsp, 8
jmp .loop_start
.do_stdin:
mov rdi, stdin
call do_read_write
.exit:
call _exit


do_read_write:
push rdi
.entry:
pop rdi
push rdi
call read
test rax, rax
je .exit
mov rdx, rax
call write
jmp .entry
.exit:
pop rdi
ret

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
; rdi should be file descriptor to read from
read:
mov rax, sys_read
mov rdx, BUFFER_SIZE
mov rsi, buffer
syscall
ret

; Writes to standard output
; rdx should be count of bytes to be written
write:
mov rax, sys_write
mov rdi, stdout
mov rsi, buffer
syscall
ret

; Exit successfully
_exit:
mov rax, sys_exit
mov rdi, success
syscall
ret


