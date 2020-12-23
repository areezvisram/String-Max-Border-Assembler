%include "simple_io.inc"

global asm_main

; initialized data
section .data
	err1: db "incorrect number of command line arguments", 0	
	err2: db "input string is too long", 0
	mes1: db "input string: ", 0
	mes3: db "border array: ", 0
	plus: db "+++  ", 0
	dots: db "...  ", 0
	spaces: db "     ", 0

; uninitialized data
section .bss
	max: resq 1
	count: resq 1
	bordar: resq 12

; logic
section .text
  arg_verifier:
	mov rax, err1
	call print_string
	call print_nl
	jmp asm_main_end
  
  arg_verifier2:
	mov rax, err2
	call print_string
	call print_nl
	jmp asm_main_end 

  maxbord:
	enter 0,0
	saveregs
	
	mov qword [max], qword 0
	
	mov r10, qword 0 ; max
	mov r15, [rbp+32] ; length of string
	mov r14, qword 1 ; isborder
	mov rbx, [rbp+24] ; the string
	mov r12, qword 0 ; counter 2, i in python
	mov rcx, qword 1
	mov rdx, r12

	FOR_LOOP1:
		mov r14, qword 1
		mov rdx, 0
		cmp rcx, r15
		jae END_FOR_LOOP1
		FOR_LOOP2:
			cmp rdx, rcx
			je END_FOR_LOOP2
			mov rax, r15
			sub rax, rcx
			add rax, rdx ; rax contains the value of L-r+i
			mov al, [rbx+rax]
			mov r8, rbx
			mov r8b, [r8 + rdx]
			cmp al, r8b
			jne NOT_EQUAL
			inc rdx
			jmp FOR_LOOP2
		END_FOR_LOOP2:
			inc rcx
			jmp maxbord_end
		NOT_EQUAL:
			mov r14, qword 0
			inc rcx
			jmp maxbord_end
		END_FOR_LOOP1:
			mov rax, qword [max] ; returning the value of max
			restoregs
			leave
			ret
  maxbord_end:
	cmp r14, qword 1
	je MATCH
	jmp FOR_LOOP1
	restoregs
	leave
	ret

        MATCH:
		mov r10, rcx
		sub r10, qword 1
		mov  qword [max], r10
		jmp FOR_LOOP1

  simple_display:
	enter 0,0
	saveregs
	
	mov r14, [rbp+32] ;r14 contains the array
	mov r12, [rbp+24]
	mov rcx, qword 1
	mov rax, mes3
	call print_string
	mov rax, [r14]
	call print_int
	FOR_LOOP3:
		cmp rcx, r12
		ja END_FOR_LOOP3
		mov al, ','
		call print_char
		mov al, ' ',
		call print_char
		mov rax, [r14+rcx*8]
		call print_int
		inc rcx
		jmp FOR_LOOP3
	END_FOR_LOOP3:
		call print_nl
		restoregs
		leave
		ret

  display_line:
	enter 0,0
	saveregs

	mov r12, [rbp+16] ; L
	mov r13, [rbp+24] ; level
	mov r14, [rbp+32] ; bordar
	
	add r12, qword 1
	mov qword [count], qword 0 ; count
	mov r15, qword 0 ; x 
		
	FOR_BORDAR:
		cmp r15, qword 12
		jae END_FOR_BORDAR
		add qword [count], qword 1

		cmp [count], r12
		ja END_FOR_BORDAR
		cmp r13, qword 1
		je IF_1
		mov rcx, [r14+r15*8]
		cmp rcx, r13
		jb IF_2
		mov rax, plus
		call print_string
		inc r15
		jmp FOR_BORDAR
		  IF_2:
			mov rax, spaces
			call print_string
			inc r15
			jmp FOR_BORDAR
		  IF_1:
			mov rcx, [r14+r15*8]
			cmp rcx, qword 0
			ja PRINT_1
			mov rax, dots
			call print_string
			inc r15
			jmp FOR_BORDAR
			PRINT_1:
				mov rax, plus
				call print_string
				inc r15
				jmp FOR_BORDAR

	END_FOR_BORDAR:
		call print_nl
		restoregs
		leave
		ret

  fancy_display:
	enter 0,0
	saveregs

	mov r14, [rbp+32] ; bordar
	mov r12, [rbp+24] ; L
	mov r13, r12 ; level
	add r13, qword 1

	FOR_DISPLAY_LINE:
		cmp r13, qword 0
		jbe END_DISPLAY_LINE
		push r14
		push r13
		push r12
		call display_line
		add rsp, 24				
		dec r13
		jmp FOR_DISPLAY_LINE
	END_DISPLAY_LINE:
		restoregs
		leave
		ret	

  asm_main:	
	enter	0,0
	saveregs

	; CHeck the number of command line arguments
	cmp rdi, qword 2
	jne arg_verifier
	
	; Check the length of the command line argument
	mov rbx, [rsi+8]
	mov r15, qword 0
	FOR_CHAR:
		mov al, byte[rbx]
		cmp al, 0
		je END_FOR_CHAR
		inc rbx
		inc r15
		jmp FOR_CHAR
	END_FOR_CHAR:
		cmp r15, qword 12
		jg arg_verifier2
		mov rax, mes1
		call print_string
		mov rax, [rsi+8]
		call print_string
		call print_nl
	
	mov rdx, qword 0
	mov r13, [rsi+8]
	mov r14, r15
	sub r15, qword 1  
	CALL_MAXBORD:
		cmp rdx, r15
		jae CALL_SIMPLE_DISPLAY
		mov r12, r14
		push r12
		push r13
		sub rsp, 8 ; fake param
		call maxbord
		add rsp, 24
		mov [bordar+rdx*8], rax ; setting the bordar value to max
		dec r14
		inc rdx
		inc r13
		jmp CALL_MAXBORD
		
	CALL_SIMPLE_DISPLAY:
		; logic to call simple display	
		push bordar
		push r15
		sub rsp, 8
		call simple_display
		add rsp, 24
		push bordar
		push r15
		sub rsp, 8
		call fancy_display
		add rsp, 24
		jmp asm_main_end
	
  asm_main_end:
	restoregs
	leave
	ret
