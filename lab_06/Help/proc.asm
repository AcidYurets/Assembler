EXTRN NUMBER : WORD					; исходное беззнаковое число в 16 c/c, записанное как обычное

PUBLIC UB							; строка - беззнаковое в 2 с/с

PUBLIC TO_UB						; перевод числа в беззнаковое в 2 с/с

DATASEG SEGMENT PARA PUBLIC 'DATA'
	UB DB 16 DUP('$'), '$'
    OUTPUT_UB_MSG DB 'Unsigned binary number: $'
DATASEG ENDS

CODESEG SEGMENT PARA PUBLIC 'CODE'
    ASSUME CS:CODESEG, DS:DATASEG
	
TO_UB PROC NEAR			; перевод числа в беззнаковое в 2 с/с
    mov AX, NUMBER		; число записано в AX
    mov DI, 15			; начинаем заполнять строку с конца	
    
	LOOP_UB:
        mov DL, AL		; очередной младший бит будет в DL
        and DL, 1
        Add DL, '0'
        mov UB[DI], DL	; записываем очередной младший бит
        
		mov CL, 1
        shr AX, CL		; переходим к следующему символу
        dec DI
        cmp DI, -1
        jne LOOP_UB
    ret
TO_UB ENDP

NEW_STR PROC NEAR					; возврат картеки и перевод на новую строку
    mov AH, 2
    mov DL, 13
    int 21H
    mov DL, 10
    int 21H
    ret
NEW_STR ENDP

OUTPUT_UB PROC NEAR					; вывод беззнакового в 2 с/с
    mov AH, 9						; вывод сообщения
    mov DX, OFFSET OUTPUT_UB_MSG
    int 21H

    call TO_UB						; перевод числа 

    mov AH, 9						; вывод числа
    mov DX, OFFSET UB
    int 21H

    call NEW_STR
    call NEW_STR

    ret
OUTPUT_UB ENDP

CODESEG ENDS
END