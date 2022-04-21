public N
public input

DSEG SEGMENT para public 'DATA'
	N dw 1 dup('0')
	inp_sign db '+'
	input_msg db 'Input signed bin number: ', 10, '$'
DSEG ENDS

CSEG SEGMENT para public 'CODE'
	assume CS:CSEG, DS:DSEG

input:
    mov ax, DSEG
	mov ds, ax
	
    mov AH, 9
    mov dx, offset input_msg				; вывод сообщения
    int 21H



	mov BX, 0					; вводить число будем в BX
    input_loop:
        mov AH, 1					; считать символ в al
        int 21H

		cmp AL, 13					; если ввели enter - закончить
        je input_end

		cmp AL, '-'
		jne minus_skip
		mov inp_sign, '-'
		jmp to_next_symbol

		minus_skip:
		sub AL, '0'

		shl BX, 1 					; сдвинуть уже записанное число
		add BL, AL					; добавить в него очередную "цифру" 

		to_next_symbol:
        jmp input_loop					; считать следующий символ

    input_end:					; конец ввода
	cmp inp_sign, '-'
	jne positive_num
    sub bx, 1
    not bx

	positive_num:
	mov N, BX				; перемещаем число в N

	ret

CSEG ENDS
END