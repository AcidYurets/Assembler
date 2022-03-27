SSEG SEGMENT para STACK 'STACK'
	db 100 dup(?)
SSEG ENDS

SD SEGMENT para public 'DATA'
	N db 1 dup('0')
	M db 1 dup('0')
	MATR db 81 dup('0')
SD ENDS

MSGS SEGMENT PARA PUBLIC 'DATA'
	ANS_MESS db 'Answer: ', 10, '$'
MSGS ENDS

CSEG SEGMENT para public 'CODE'
	assume CS:CSEG, ES:SD, DS:MSGS, SS:SSEG

ans_message:
	mov dx, offset ANS_MESS
    mov ah,9
    int 21h
	ret

read_num: ; Ввод цифры, которая будет в DH
	mov ah, 1
	int 21h
	mov dh, al
	int 21h ; Ввод пробела
	
	sub dh, 48
	ret

read_matr: ; Ввод матрицы
	mov cx, 0
	mov cl, N
	mov bx, 0
	read_matr_loop:
		call read_line
		add bl, M ; Увеличиввем первый индекс массива для правильной адресации
		loop read_matr_loop
	ret

read_line:
	push cx
	mov cl, M
	mov si, 0
	
	read_elem_loop:
		call read_num
		mov matr[bx][si], dh
		inc si
		loop read_elem_loop
		
	pop cx
	ret

print_num: ; Вывод символа из DH с пробелом после него
	add dh, 48

	mov ah, 2
	mov dl, dh
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

print_matr: ; Вывод матрицы
	mov cx, 0
	mov cl, N
	mov bx, 0
	print_matr_loop:
		call print_line
		add bl, M ; Увеличиввем первый индекс массива для правильной адресации
		call end_of_line
		loop print_matr_loop
	ret

print_line:
	push cx
	mov cl, M
	mov si, 0
	
	print_elem_loop:
		mov dh, matr[bx][si]
		call print_num
		inc si
		loop print_elem_loop
		
	pop cx
	ret


change_matr_elems: ; В bx должно быть M * (индекс строки), в si - номер элемента, который меняем с последующим
	xchg ah, matr[bx][si] ; в ah будет i-ый
	xchg ah, matr[bx][si + 1] ; в ah будет i + 1, а в i + 1 будет i-ый
	xchg ah, matr[bx][si] ; в i-ом будет i + 1
	ret

change_elems_in_line: ; В al должно быть кол-во обменов, а bx = M * (индекс строки)
	push cx

	mov cx, 0
	mov cl, al ; В cx записали необходимое кол-во обменов в одной строке
	mov si, 0

	cmp cx, 0
	jle skip

	change_elems_in_line_loop:
		call change_matr_elems
		add si, 2
		loop change_elems_in_line_loop

	skip:
	pop cx

	ret

change_matr: ; Меняет соседние столбцы местами
	mov ax, 0
	mov al, M
	mov bl, 2
	div bl

	mov bx, 0
	mov cx, 0
	mov cl, N

	change_matr_lines:
		call change_elems_in_line
		add bl, M
		loop change_matr_lines

	ret

main:
	mov ax, SD
	mov es, ax

	mov ax, MSGS
	mov ds, ax

	; Ввод N и M
	call read_num
	mov N, dh
	
	call read_num
	mov M, dh

	call read_matr

	call change_matr

	call ans_message
	call print_matr

	mov ax, 4c00h
	int 21h
CSEG ENDS
END main