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
mov rdi, 0
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
mov rax, 0 ; syscall number for SYS_read
mov rdx, BUFFER_SIZE
mov rsi, buffer
syscall
ret

; Writes to standard output
; rdx should be count of bytes to be written
write:
mov rax, 1 ; syscall number for SYS_write
mov rdi, 1 ; 1 -> fd for stdout
mov rsi, buffer
syscall
ret

; Exit successfully
_exit:
mov rax, 60
mov rdi, 0
syscall
ret


