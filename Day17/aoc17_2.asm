; nasm -f elf64 aoc17_2.asm -o aoc17_2.o && ld aoc17_2.o -o aoc17_2 && ./aoc17_2
; callee-saved-registers: rdi, rsi, rbp, rbx

;; storage for data ;;
section .data
    debug_msg: db "Debug here", 10                              ; debug message
    debug_msg_size: equ $ - debug_msg                           ; length of debug message
    debug_msg_2: db "Debug here 2", 10                          ; debug message 2
    debug_msg_size_2: equ $ - debug_msg_2                       ; length of debug message 2
    print_buffer: db ".....................", 10                ; 21 whitespaces and 1 newline = 22 chars
    print_buffer_size: equ $ - print_buffer                     ; length of print buffer
    ;program: db 0,3,5,4,3,0                                     ; program code (TEST) -> should return 117440
    program: db 2,4,1,3,7,5,4,1,1,3,0,3,5,5,3,0                 ; program code (REAL)
    program_size: equ $ - program                               ; program size in bytes
    program_check: dq 0                                         ; number of last digits to check in program
    a_init: dq 0                                                ; initial value of A register

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

    xor r8,  r8                     ; A (R8 ) register
    xor r9,  r9                     ; B (R9 ) register
    xor r10, r10                    ; B (R10) register


;; functionality of runing differnet programs
main:
    
    xor rax, rax                    ; set rax to 0
    mov rbx, 1                      ; set rbx to 1
    xor rdx, rdx                    ; set rdx to 0

main_loop:
    cmp rbx, program_size           ; compare rbx and length of program
    jg main_done                    ; we are done
    cmp rbx, 0                      ; compare rbx and 0
    jl main_done                    ; we are done

    shl rax, 3                      ; left shift of rax 3 times
    mov rcx, rdx                    ; move rdx into rcx

main_loop_c:
    cmp rcx, 8                      ; compare rcx and 8
    jge mein_loop_c_end             ; if greater equal: jump to end of main_loop_c (main_loop_c_end)
    mov [program_check], rbx        ; number of last program elements to check
    push rax                        ; push rax on the stack
    add rax, rcx                    ; add rcx to rax
    mov [a_init], rax               ; move into new a_init
    push rbx                        ; push rbx, rcx, rdx on the stack
    push rcx
    push rdx
    call program_run                ; call procedure to check program
    mov rdi, rcx                    ; move result of procedure from rcx in rdi
    pop rdx                         ; pop rdx, rcx, rbx, rax from the stack
    pop rcx
    pop rbx
    pop rax
    cmp rdi, 1                      ; compare result of procedure and 1
    je main_loop_c_done             ; if equal: we are done in c loop
    inc rcx                         ; increase rcx and loop c loop
    jmp main_loop_c

mein_loop_c_end:
    dec rbx                         ; decrement rbx
    shr rax, 3                      ; shift right of rax 3 times
    push rax                        ; push rax on the stack
    and rax, 7                      ; rax = rax % 8
    inc rax                         ; increse rax
    mov rdx, rax                    ; move rax into rdx
    pop rax                         ; pop rax from the stack
    shr rax, 3                      ; shift right of rax 3 times
    jmp main_loop                   ; jump to main_loop

main_loop_c_done:
    inc rbx                         ; increment rbx
    add rax, rcx                    ; rax = rax + rcx
    xor rdx, rdx                    ; rdx = 0
    jmp main_loop                   ; jump to main_loop

main_done:
    ;; print initial value of A register and exit

    mov rdx, [a_init]               ; print start contents of A register
    call print_rdx

    jmp exit                        ; exit the program


;; functionality for initializing program with next A ;;
;; program returns on rcx 0 if not and 1 if is valid ;;
program_run:
    ; initialize program

    mov r8, [a_init]                ; get last initial value of A register
    mov rdi, program_size           ; get length of program into rdi
    sub rdi, [program_check]        ; get offset to last digits we want to check

    lea rsi, [program]              ; RSI is not instruction pointer and points to first program opcode


;; functionality for to run the provided program ;;
program_loop:
    ; run given program

    ; check if we reached end of buffer
    lea rdx, [program]              ; load start of program
    add rdx, program_size           ; add program lengh
    cmp rsi, rdx                    ; compare program pointer and end of program
    jge program_check_exit          ; if greater equal: try exit if greater equal
    
    ; fetch opcode and operand
    xor rbx, rbx                    ; clear EBX
    xor rdx, rdx                    ; clear EDX
    mov bl, byte [rsi]              ; load opcode in BL (lower part of EBX)
    mov dl, byte [rsi + 1]          ; load literal operand in RDX
    add rsi, 2                      ; increase instruction pointer (RSI) by 2

    jmp [lookup_inst + 8 * ebx]     ; jump to opcode command


;; functionality to check if program should really exit ;;
program_check_exit:
    ; check if length of produced program matches program size and exit
    xor rcx, rcx                    ; set rcx to 0
    cmp rdi, program_size           ; compare produced program length (rdi) and actual program size
    jne program_exit                ; if not equal: exit
    inc rcx                         ; set rcx to 1


;; functionality to exit program ;;
program_exit:
    ret                             ; return from procedure


;; functionality to exit program when we definitely failed ;;
program_exit_fail:
    xor rcx, rcx                    ; set rcx to 0
    ret                             ; return from procedure


;; different opcodes ;;
adv:
    ; OPCODE 0
    ;  A = A div (2 ^ CO)
    call combo_operands             ; we need combo operands here
    mov cl, dl                      ; shr instruction is only working on cl (whyever)
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

    cmp rdi, program_size           ; check rdi and length of program
    jg program_exit_fail            ; if greater: reinitialize program

    xor rax, rax
    mov al, byte [program + edi]
    cmp dl, al                      ; compare rdx with value in program[rdi]
    jne program_exit_fail           ; if not equal: reinitialize program
    inc rdi

    jmp program_loop                ; jump back to program loop

bdv:
    ; OPCODE 6
    ;  B = A div (2 ^ CO)
    call combo_operands             ; we need combo operands here
    mov cl, dl                      ; shr instruction is only working on cl (whyever)
    mov r9, r8                      ; copy r8 in r9
    shr r9, cl                      ; r9 = r9 >> cl (lowest 8 bits of rdx - might be wrong to do so)
    jmp program_loop                ; jump back to program loop

cdv:
    ; OPCODE 6
    ;  C = A div (2 ^ CO)
    call combo_operands             ; we need combo operands here
    mov cl, dl                      ; shr instruction is only working on cl (whyever)
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
    ret                             ; return from procedure

jump_combo_operands:
    sub rdx, 4                      ; subtract 4 from EDX
    jmp [lookup_combo + 8 * edx]    ; jump to according register set function

set_a:
    mov rdx, r8                     ; load A (R8) into rdx
    ret                             ; return from procedure

set_b:
    mov rdx, r9                     ; load B (R9) into rdx
    ret                             ; return from procedure

set_c:
    mov rdx, r10                    ; load C (R10) into rdx
    ret                             ; return from procedure


;; functionality for printing the contents of the rdx register ;;
print_rdx:
    ; prints contents of rdx

    push rdx                        ; push rdx, rbx, rcx, rax on the stack
    push rbx
    push rcx
    push rax
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
    pop rax                         ; pop rax, rcx, rbx, rdx from stack
    pop rcx
    pop rbx
    pop rdx
    ret                             ; return from procedure

divide_by_ten:
    ; divide rax by 10, store modulo into rdx
    xor rdx, rdx                    ; clear rdx
    mov rcx, 10                     ; rcx = 10
    div rcx                         ; rax = rax // rcx, rdx = rax % rcx
    ret                             ; return from procedure


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
    ret                             ; return from procedure clear_print_buffer
    

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
    ret                             ; return from procedure


;; functionality for printing debug message ;;
print_debug:
    ; print the debug message

    push rdi                        ; push rdi, rsi, rax, rdx on the stack
    push rsi
    push rax
    push rdx
    mov rax, 1                      ; write syscall
    mov rdi, 1                      ; file descriptor: 1 - stdout
    mov rsi, debug_msg              ; pointer to debug message
    mov rdx, debug_msg_size         ; length of debug messsage
    syscall                         ; do syscall
    pop rdx                         ; pop rdx, rax, rsi, rdi from the stack
    pop rax
    pop rsi
    pop rdi
    ret                             ; return from procedure


;; functionality for printing debug message 2 ;;
print_debug_2:
    ; print the debug message 2

    push rdi                        ; push rdi, rsi, rax, rdx on the stack
    push rsi
    push rax
    push rdx
    mov rax, 1                      ; write syscall
    mov rdi, 1                      ; file descriptor: 1 - stdout
    mov rsi, debug_msg_2            ; pointer to debug message
    mov rdx, debug_msg_size_2       ; length of debug messsage
    syscall                         ; do syscall
    pop rdx                         ; pop rdx, rax, rsi, rdi from the stack
    pop rax
    pop rsi
    pop rdi
    ret                             ; return from procedure
