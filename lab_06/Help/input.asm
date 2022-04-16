PUBLIC NUMBER						; исходное беззнаковое число в 16 c/c, записанное как обычно
PUBLIC INPUT_UH						; ввод беззнакового в 16 с/c

DATASEG SEGMENT PARA PUBLIC 'DATA'
    NUMBER DW 0
	INPUT_UH_MSG DB 'Enter unsigned hexadecimal number (from 0000 to FFFF): $'
DATASEG ENDS

CODESEG SEGMENT PARA PUBLIC 'CODE'
    ASSUME CS:CODESEG, DS:DATASEG
	
INPUT_UH PROC NEAR					; ввод беззнакового в 16 с/c
	mov AH, 9					; вывод сстроки из DS:DX
	mov DX, OFFSET INPUT_UH_MSG
	int 21H

	mov BX, 0					; вводить число будем в BX

    INSYMB:
        mov AH, 1					; считать символ в al
        int 21H
        
		cmp AL, 13					; если ввели enter - закончить
        je END_INPUT_UH
		
		sub AL, '0'
		cmp AL, 10					; если ввели букву - вычесть 7 (до кода ASCII)
		jl ADD_NUMBER
		sub AL, 7
	ADD_NUMBER:	
		mov CL, 4
		sal BX, CL					; сдвинуть уже записанное число
		add BL, AL					; добавить в него очередную "цифру" 
        jmp INSYMB					; считать следующий символ

    END_INPUT_UH:					; конец ввода
		mov NUMBER, BX				; перемещаем число в NUMBER
		ret

INPUT_UH ENDP

CODESEG ENDS
END
	
