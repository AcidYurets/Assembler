public N
public input

DSEG SEGMENT para public 'DATA'
	N dw 1 dup('0')
DSEG ENDS

CSEG SEGMENT para public 'CODE'
	assume CS:CSEG, DS:DSEG

input:
	mov BX, 0					; вводить число будем в BX

    input_loop:
        mov AH, 1					; считать символ в al
        int 21H

		cmp AL, 13					; если ввели enter - закончить
        je input_end
		
		sub AL, '0'

		shl BX, 1 					; сдвинуть уже записанное число
		add BL, AL					; добавить в него очередную "цифру" 
        jmp input_loop					; считать следующий символ

    input_end:					; конец ввода
    mov ax, DSEG
	mov ds, ax
	mov N, BX				; перемещаем число в N

	ret

CSEG ENDS
END