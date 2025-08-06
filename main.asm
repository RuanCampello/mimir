format ELF64 executable 3

segment readable writeable
msg db "Hello, World!", 0xa
msg_size = $ - msg

segment readable executable
entry start

start:
  mov rax, 1
  mov rdi, 1
  mov rsi, msg
  mov rdx, msg_size
  syscall

  mov rax, 60
  mov rdi, 0
  syscall
