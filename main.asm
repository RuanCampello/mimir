format ELF64 executable

SYS_OUT = 1 ;; stdout

macro write fd, buf, count {
  mov rax, 1 ;; write syscall
  mov rdi, fd 
  mov rsi, buf

  mov rdx, count
  syscall
}

macro exit code {
    mov rax, 60 ;; exit syscall
    mov rdi, code
    syscall
}

segment readable executable
entry main

main:
  write 1, welcome, welcome_len

  ;; now we need to read user input
  mov rax, 0 ;; read syscall
  mov rdi, 1
  mov rsi, input_buffer
  mov rdx, 4096
  syscall

  exit 0

;; -----------------------

segment readable writable

input_buffer rb 4096

welcome db "Mimir - don't forget", 10
welcome_len = $ - welcome

prompt db "> ", 0

msg_set       db "[SET] command received", 10, 0
msg_get       db "[GET] command received", 10, 0
unknown       db "[?] Unknown command", 10, 0

set_pref      db "SET"
set_pref_len  = $ - set_pref

get_pref      db "GET"
get_pref_len  = $ - get_pref

