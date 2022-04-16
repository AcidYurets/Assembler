EXTRN NUMBER : WORD					; исходное беззнаковое число в 16 c/c, записанное как обычное

DATASEG SEGMENT PARA PUBLIC 'DATA'
    oct db 6 dup('0'), '$'
    sign db ' '
    OUTPUT_SO_MSG DB 'Signed octant number: $'
DATASEG ENDS

CODESEG SEGMENT PARA PUBLIC 'CODE'
    ASSUME CS:CODESEG, DS:DATASEG
	
to_oct:
    mov ax, NUMBER

    cmp ax, 32767
    jbe nosign

    mov sign, '-'

    sub ax, 1
    not ax

    nosign:

    mov bx, 5

    trans_oct:
        mov dx, ax

        and dx, 7

        add dl, '0'

        mov oct[bx], dl

        mov cl, 3
        shr ax, cl

        dec bx

        cmp bx, -1
        jne trans_oct

    ret
	

NEW_STR_1 PROC NEAR					; возврат картеки и перевод на новую строку
    mov AH, 2
    mov DL, 13
    int 21H
    mov DL, 10
    int 21H
    ret
NEW_STR_1 ENDP

print_oct:
    mov cx, 6
    mov bx, 0

    mov dl, sign

    mov ah, 2
    int 21h

    loop_out: 
        mov ah, 2

        mov dl, oct[bx]

        inc bx

        int 21h
        
        loop loop_out

    mov sign, ' '

    ret

OUTPUT_SO PROC NEAR				
    mov AH, 9						; вывод сообщения
    mov DX, OFFSET OUTPUT_SO_MSG
    int 21H

    call to_oct				; перевод числа 

	call print_oct

    call NEW_STR_1
    call NEW_STR_1

    RET
OUTPUT_SO ENDP

CODESEG ENDS
END
