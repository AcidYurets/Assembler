PUBLIC N
EXTRN print_num: near ; В пределах того же сегмента

SSEG SEGMENT PARA STACK 'STACK'
	db 100 dup (0)
SSEG ENDS

DSEG SEGMENT PARA PUBLIC 'DATA'
	N db 1 dup (0)
DSEG ENDS

CSEG SEGMENT PARA PUBLIC 'CODE'
	assume CS:CSEG, DS:DSEG, SS:SSEG

read_num: ; Ввод цифры, которая будет в BH
	mov ah, 1
	int 21h
	mov bh, al
	
	sub bh, 48
	ret

main:
	mov ax, DSEG
	mov ds, ax

	call read_num
	mov N, bh
	add bh, bh
	call print_num

	mov ax, 4c00h
	int 21h
CSEG ENDS


END main