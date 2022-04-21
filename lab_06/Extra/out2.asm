extern N: word				; исходное знаковое число, записанное как обычное
extern newline: near
public output_bin

DSEG SEGMENT PARA PUBLIC 'DATA'
    binN db 16 dup('0'), '$'
    OUTPUT_bin_MSG db 'Unsigned bin number: $'
DSEG ENDS

CSEG SEGMENT PARA PUBLIC 'CODE'
    ASSUME CS:CSEG, DS:DSEG
	
to_bin:
	mov ax, N

    mov bx, 15

    trans_bin:
        mov dx, ax

        and dx, 1

        add dl, '0'

        mov binN[bx], dl

        mov cl, 1
        shr ax, cl

        dec bx

        cmp bx, -1
        jne trans_bin

    ret


print_bin:
    mov AH, 9	
    mov dx, offset binN
    int 21H

    ret

output_bin proc near
    mov ax, DSEG
	mov ds, ax

    mov AH, 9	
    mov dx, offset OUTPUT_bin_MSG					; вывод сообщения
    int 21H

    call to_bin				; перевод числа 

	call print_bin

    call newline
    call newline

    ret
output_bin ENDP

CSEG ENDS
END
