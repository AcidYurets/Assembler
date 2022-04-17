extern N: word				; исходное знаковое число, записанное как обычное
extern newline: near
public output_dec

DSEG SEGMENT PARA PUBLIC 'DATA'
    decN db 5 dup('0'), '$'
    sign db ' '
    OUTPUT_dec_MSG db 'Signed decimal number: $'
DSEG ENDS

CSEG SEGMENT PARA PUBLIC 'CODE'
    ASSUME CS:CSEG, DS:DSEG
	
to_dec:
	mov ax, N

    cmp ax, 32767
    jbe nosign

    mov sign, '-'

    sub ax, 1
    not ax

    nosign:

    mov bx, 4

    trans_dec:
        mov dx, 0
        mov cx, 10
        div cx ; AX - результат, DX - остаток

        add dl, '0'

        ; push ax
        ; ;; PRINT
        ; ;mov dl, al
        ; mov ah, 2
        ; int 21h
        ; call newline
        ; ;; PRINT
        ; pop ax

        mov decN[bx], dl

        dec bx

        cmp bx, -1
        jne trans_dec

    ret


print_dec:
    mov bx, 0
    mov dl, sign

    mov ah, 2
    int 21h

    mov AH, 9	
    mov dx, offset decN
    int 21H

    mov sign, ' '

    ret

output_dec proc near
    mov ax, DSEG
	mov ds, ax

    mov AH, 9	
    mov dx, offset OUTPUT_dec_MSG					; вывод сообщения
    int 21H

    call to_dec				; перевод числа 

	call print_dec

    call newline
    call newline

    ret
output_dec ENDP

CSEG ENDS
END