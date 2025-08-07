;; computes the length of a null terminated string
strlen:
  push rdi
  xor rax, rax

  .next_char:
    mov al, byte [rdi]
    cmp rax, 0
    je .done

    inc rdi
    jmp .next_char

  .done:
    pop rsi
    sub rdi, rsi
    mov rax, rdi

    ret

;; compares if text starts with the prefix
starts_with:
  cmp rsi, r10
  jl .false  ;; if input length < prefix length => can't match

  xor rax, rax         ;; rax = counter (0)
.loop:
  cmp rax, r10
  je .true             ;; matched all prefix bytes

  mov bl, [rdi + rax]
  mov bh, [rdx + rax]
  cmp bl, bh
  jne .false

  inc rax
  jmp .loop

.true:
  mov rax, 1
  ret

.false:
  xor rax, rax
  ret

