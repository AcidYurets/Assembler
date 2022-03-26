PUBLIC print_num
EXTRN N: byte

CSEG SEGMENT PARA PUBLIC 'CODE'
	assume CS:CSEG

print_num: ; Вывод символа из BH
	add bh, 48

	mov ah, 2
    mov dl, 32 ; Пробел
	int 21h

	mov dl, bh
	int 21h
	ret

CSEG ENDS
END