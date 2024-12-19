; nasm -f elf64 aoc17_1.asm -o aoc17_1.o && ld aoc17_1.o -o aoc17_1 && ./aoc17_1
; callee-saved-registers: rdi, rsi, rbp, rbx

;; storage for data ;;
section .data
    debug_msg: db "Debug here", 10                              ; debug message
    debug_msg_size: equ $ - debug_msg                           ; length of debug message
    print_buffer: db ".....................", 10                ; 21 whitespaces and 1 newline = 22 chars
    print_buffer_size: equ $ - print_buffer                     ; length of print buffer
    ;program: db 0,1,5,4,3,0                                     ; program code (TEST - PART 1)
    ;program: db 0,3,5,4,3,0                                     ; program code (TEST - PART 2)
    program: db 2,4,1,3,7,5,4,1,1,3,0,3,5,5,3,0                 ; program code (REAL)
    program_size: equ $ - program                               ; program size in bytes

;; storage for lookup tables ;;
section .rodata
    lookup_inst: dq adv, bxl, bst, jnz, bxc ,out, bdv, cdv      ; jump table for instructions
    lookup_combo: dq set_a, set_b, set_c                        ; jump table for combo operands

;; storage for code ;;
section .text
    global  _start

;; functionality for initial setup ;;
_start:
    ; initialize registers A, B, C
    ;mov r8,  729                    ; A (R8 ) register (TEST)
    ;mov r9,  0                      ; B (R9 ) register (TEST)
    ;mov r10, 0                      ; B (R10) register (TEST)
    ; should produce: 4,6,3,5,6,3,5,2,1,0

    mov r8,  37283687               ; A (R8 ) register (REAL)
    mov r9,  0                      ; B (R9 ) register (REAL)
    mov r10, 0                      ; C (R10) register (REAL)

    ; set instruction pointer (RSI) to start of program
    lea rsi, [program]              ; RSI is not instruction pointer and points to first program opcode


;; functionality for to run the provided program ;;
program_loop:
    ; run given program

    ; check if we reached end of buffer
    lea rdx, [program]              ; load start of program
    add rdx, program_size           ; add program lengh
    cmp rsi, rdx                    ; compare program pointer and end of program
    jge exit                        ; exit if greater equal
    
    ; fetch opcode and operand
    xor rbx, rbx                    ; clear EBX
    xor rdx, rdx                    ; clear EDX
    mov bl, byte [rsi]              ; load opcode in BL (lower part of EBX)
    mov dl, byte [rsi + 1]          ; load literal operand in RDX
    add rsi, 2                      ; increase instruction pointer (RSI) by 2

    jmp [lookup_inst + 8 * ebx]     ; jump to opcode command


;; different opcodes ;;
adv:
    ; OPCODE 0
    ;  A = A div (2 ^ CO)
    call combo_operands             ; we need combo operands here
    mov cl, dl                      ; shr instruction is not working on dl (whyever)
    shr r8, cl                      ; r8 = r8 >> cl (lowest 8 bits of rdx - might be wrong to do so)
    jmp program_loop                ; jump back to program loop

bxl:
    ; OPCODE 1
    ; B = B xor LO
    xor r9, rdx                     ; r9 = r9 xor rdx
    jmp program_loop                ; jump back to program loop

bst:
    ; OPCODE 2
    ; B = CO mod 8
    call combo_operands             ; we need combo operands here
    and rdx, 7                      ; rdx = rdx mod 8
    mov r9, rdx                     ; r9 = rdx
    jmp program_loop                ; jump back to program loop

jnz:
    ; OPCODE 3
    ; IF A != 0 THEN instruction pointer = LO
    cmp r8, 0                       ; compare r8 and 0
    je program_loop                 ; if equal: jump back to program loop
    lea rsi, [program + 2 * edx]    ; set instruction pointer to new address
    jmp program_loop                ; jump back to program loop

bxc:
    ; OPCODE 4
    ; B = B xor C
    xor r9, r10                     ; r9 = r9 xor r10
    jmp program_loop                ; jump back to program loop

out:
    ; OPCODE 5
    ; print (rdx mod 8)
    call combo_operands             ; we need combo operands here
    and rdx, 7                      ; rdx = rdx mod 8
    push rax                        ; save rax to the stack
    call print_rdx                  ; print rdx
    pop rax                         ; restore rax from the stack
    jmp program_loop                ; jump back to program loop

bdv:
    ; OPCODE 6
    ;  B = A div (2 ^ CO)
    call combo_operands             ; we need combo operands here
    mov cl, dl                      ; shr instruction is not working on dl (whyever)
    mov r9, r8                      ; copy r8 in r9
    shr r9, cl                      ; r9 = r9 >> cl (lowest 8 bits of rdx - might be wrong to do so)
    jmp program_loop                ; jump back to program loop

cdv:
    ; OPCODE 6
    ;  C = A div (2 ^ CO)
    call combo_operands             ; we need combo operands here
    mov cl, dl                      ; shr instruction is not working on dl (whyever)
    mov r10, r8                     ; copy r8 in r10
    shr r10, cl                     ; r10 = r10 >> cl (lowest 8 bits of rdx - might be wrong to do so)
    jmp program_loop                ; jump back to program loop


;; functionality for safely exiting the program ;;
exit:
    ; exits the program

    mov rax, 60                     ; exit syscall
    xor rdi, rdi                    ; exit status 0
    syscall                         ; do syscall


;; functionality for resolving combo operands ;;
combo_operands:
    ; resolve combo operands

    cmp rdx, 4                      ; compare operand (RDX) to 4
    jge jump_combo_operands         ; jump to combo functions if greater (4, 5, 6)
    ret                             ; return from subroutine

jump_combo_operands:
    sub rdx, 4                      ; subtract 4 from EDX
    jmp [lookup_combo + 8 * edx]    ; jump to according register set function

set_a:
    mov rdx, r8                     ; load A (R8) into rdx
    ret                             ; return from subroutine

set_b:
    mov rdx, r9                     ; load B (R9) into rdx
    ret                             ; return from subroutine

set_c:
    mov rdx, r10                    ; load C (R10) into rdx
    ret                             ; return from subroutine


;; functionality for printing the contents of the rdx register ;;
print_rdx:
    ; prints contents of rdx

    push rdx                        ; push rdx, rbx on the stack
    push rbx
    call clear_print_buffer         ; clear the print buffer
    mov rax, rdx                    ; copy rdx into rax
    mov ebx, 19                     ; initialize ecx with 20

loop_print_rdx:
    call divide_by_ten              ; get first digit into rax and remainder in rdx
    cmp ebx, 0                      ; check if end of buffer
    jl ret_print_rdx                ; jump to end of loop
    add dl, 48                      ; add ascii offset of '0' to modulo
    mov [print_buffer + ebx], dl    ; put dl in buffer
    cmp rax, 0                      ; check if end of number
    je ret_print_rdx                ; jump to end of loop
    dec ebx                         ; decrease ecx
    jmp loop_print_rdx              ; loop

ret_print_rdx:
    call print_print_buffer         ; print the print buffer
    pop rbx                         ; pop rbx, rdx from stack
    pop rdx
    ret                             ; return from subroutine

divide_by_ten:
    ; divide rax by 10, store modulo into rdx
    xor rdx, rdx                    ; clear rdx
    mov rcx, 10                     ; rcx = 10
    div rcx                         ; rax = rax // rcx, rdx = rax % rcx
    ret                             ; return from subroutine


;; functionality for clearing the print_buffer ;;
clear_print_buffer:
    ; clears the print buffer

    mov ecx, 0                      ; initialize the loop with ecx=0
    mov al, ' '                     ; set al to a space

loop_clear_print_buffer:
    cmp ecx, 21                     ; check if we reached the 20th element
    je ret_clear_print_buffer       ; jump to end of the loop
    mov [print_buffer + ecx], al    ; put space in location
    inc ecx                         ; increase ecx
    jmp loop_clear_print_buffer     ; loop

ret_clear_print_buffer:
    ret                             ; return from subroutine clear_print_buffer
    

;; functionality for printing the print_buffer ;;
print_print_buffer:
    ; print the print_buffer

    push rdi                        ; push rdi, rsi on the stack
    push rsi
    mov rax, 1                      ; write syscall
    mov rdi, 1                      ; file descriptor: 1 - stdout
    mov rsi, print_buffer           ; pointer to buffer
    mov rdx, print_buffer_size      ; length of buffer
    syscall                         ; do syscall
    pop rsi                         ; pop rsi, rdi from the stack
    pop rdi
    ret                             ; return from subroutine


;; functionality for printing debug message ;;
print_debug:
    ; print the debug message

    push rdi                        ; push rdi, rsi on the stack
    push rsi
    mov rax, 1                      ; write syscall
    mov rdi, 1                      ; file descriptor: 1 - stdout
    mov rsi, debug_msg              ; pointer to debug message
    mov rdx, debug_msg_size         ; length of debug messsage
    syscall                         ; do syscall
    pop rsi                         ; pop rsi, rdi from the stack
    pop rdi
    ret                             ; return from subroutine

