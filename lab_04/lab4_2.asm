PUBLIC output
EXTRN S: byte

CSEG SEGMENT PARA PUBLIC 'CODE'
	assume CS:CSEG

output_char:
	mov ah, 2
	int 21h
	mov dl, 13
	int 21h
	mov dl, 10
	int 21h
	ret

output:
	mov dl, [s+2+0] ;Первая буква
	call output_char
	mov dl, [s+2+3]
	call output_char
	mov dl, [s+2+6]
	call output_char
	mov dl, [s+2+9]
	call output_char
	ret

CSEG ENDS
END