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

macro check_pref buf, buf_len, pref, pref_len, jump_label {
  mov rdi, buf
  mov rsi, buf_len
  mov rdx, pref
  mov r10, pref_len

  call starts_with
  cmp rax, 1

  je jump_label
}

segment readable executable
include "strings.inc"

entry main

main:
  write 1, welcome, welcome_len

  ;; now we need to read user input
  mov rax, 0 ;; read syscall
  mov rdi, 1
  mov rsi, input_buffer
  mov rdx, 4096
  syscall

  test rax, rax ;; this is basically a if rax <= 0
  jle .fail ;; if so, we jump to error

  ;; remove the newline from the input
  mov rcx, rax ;; length
  mov rbx, input_buffer
  .remove_nl:
    cmp byte [rbx], 10
    je .found_nl
    inc rbx
    loop .remove_nl
    jmp .after_nl
  .found_nl:
    mov byte [rbx], 0
    mov rcx, rbx
    sub rcx, input_buffer
  .after_nl:

  ;; check if it's a set or get cmd
  check_pref input_buffer, rcx, set_pref, set_pref_len, .is_set
  check_pref input_buffer, rcx, get_pref, get_pref_len, .is_get


  .fail:
    write SYS_OUT, unknown, unknown_len
    exit 1

  .is_set:
    write SYS_OUT, msg_set, msg_set_len
    exit 0

  .is_get:
    write SYS_OUT, msg_get, msg_get_len
    exit 0


;; -----------------------

segment readable writable

input_buffer rb 4096

welcome db "Mimir - don't forget", 10
welcome_len = $ - welcome

prompt db "> ", 0

msg_set       db "[SET] command received", 10
msg_set_len   = $ - msg_set
msg_get       db "[GET] command received", 10
msg_get_len   = $ - msg_get
unknown       db "[?] Unknown command", 10
unknown_len   = $ - unknown

set_pref      db "SET"
set_pref_len  = $ - set_pref

get_pref      db "GET"
get_pref_len  = $ - get_pref

