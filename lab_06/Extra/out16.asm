extern N: word				; исходное знаковое число, записанное как обычное
extern newline: near
public output_hex

DSEG SEGMENT PARA PUBLIC 'DATA'
    hexN db 4 dup('0'), '$'
    sign db ' '
    OUTPUT_hex_MSG db 'Signed hex number: $'
DSEG ENDS

CSEG SEGMENT PARA PUBLIC 'CODE'
    ASSUME CS:CSEG, DS:DSEG
	
to_hex:
    mov ax, N

    cmp ax, 32767
    jbe nosign

    mov sign, '-'

    sub ax, 1
    not ax

    nosign:

    mov bx, 3

    trans_hex:
        mov dx, ax

        and dx, 15

        add dl, '0'

        cmp dl , '9'
        jle numeral

        add dl, 7

        numeral:
        mov hexN[bx], dl

        mov cl, 4
        shr ax, cl

        dec bx

        cmp bx, -1
        jne trans_hex

    ret

print_hex:
    mov bx, 0
    mov dl, sign

    mov ah, 2
    int 21h

    mov AH, 9	
    mov dx, offset hexN
    int 21H

    mov sign, ' '

    ret

output_hex proc near
    mov ax, DSEG
	mov ds, ax

    mov AH, 9	
    mov dx, offset OUTPUT_hex_MSG					; вывод сообщения
    int 21H

    call to_hex				; перевод числа 

	call print_hex

    call newline
    call newline

    ret
output_hex ENDP

CSEG ENDS
END