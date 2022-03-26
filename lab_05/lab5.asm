SSEG SEGMENT para STACK 'STACK'
	db 100 dup(?)
SSEG ENDS

SD SEGMENT para public 'DATA'
	N db 1 dup('0')
	M db 1 dup('0')
	NM db 1 dup('0')
	MATR db 81 dup('0')
SD ENDS


CSEG SEGMENT para public 'CODE'
	assume CS:CSEG, DS:SD, SS:SSEG

read_num: ; Ввод цифры, которая будет в BH
	mov ah, 1
	int 21h
	mov bh, al
	int 21h
	
	sub bh, 48
	ret

read_matr: ; Ввод матрицы
	mov cx, 0
	mov cl, N
	mov si, 0
	read_matr_loop:
		push cx
		mov cl, M
		mov di, 0
		read_line:
			push di
			mov ax, 0
			mov al, M
			mul si           ; \
  			add di, ax       ; | Определение индекса
			mov MATR[di], bh ; /
			pop di
			call read_num
			inc di
			loop read_line
		
		pop cx
		inc si
		loop read_matr_loop
	ret

print_num: ; Вывод символа из BH с пробелом после него
	add bh, 48

	mov ah, 2
	mov dl, bh
	int 21h
	mov dl, 32
	int 21h
	ret

end_of_line: ; Переход на новую строку
	mov ah, 2
	mov dl, 13
	int 21h
	mov dl, 10
	int 21h
	ret

print_matr: ; Вывод матрицы MATR
	mov cx, 0
	mov cl, N
	mov si, 0
	print_matr_loop:
		push cx
		mov cl, M
		mov di, 0
		print_line:
			push di
			mov ax, 0
			mov al, M
			mul si           ; \
  			add di, ax       ; | Определение индекса
			mov bh, MATR[di] ; /
			pop di
			call print_num
			inc di
			loop print_line
		
		call end_of_line
		pop cx
		inc si
		loop print_matr_loop
	ret
	

main:
	mov ax, SD
	mov ds, ax
	; Ввод N и M
	call read_num
	mov N, bh
	call read_num
	mov M, bh

	call read_matr
	call print_matr

	mov ax, 4c00h
	int 21h
CSEG ENDS
END main