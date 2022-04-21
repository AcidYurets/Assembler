extern input: near
extern output_bin: near
extern output_hex: near
extern N: word
public newline

SSEG SEGMENT para STACK 'STACK'
	db 100 dup(?)
SSEG ENDS

MSGS SEGMENT PARA PUBLIC 'DATA'

	Menu db 'Menu: ', 10
	db '0. Exit', 10
	db '1. Input number as unsigned in 8 c/c', 10
	db '2. Print number as unsigned in 2 c/c', 10
	db '3. Print number as signed in 16 c/c', 10, '$'
	Actions dw exit, input, output_bin, output_hex
MSGS ENDS

CSEG SEGMENT para public 'CODE'
	assume CS:CSEG, DS:MSGS, SS:SSEG

show_menu:
	mov ax, MSGS
	mov ds, ax

	mov dx, offset Menu
    mov ah, 9
    int 21h
	ret

newline:
	mov DL, 10 ; возврат картеки и перевод на новую строку
    mov AH, 2
    int 21h
    mov DL, 13
    mov AH, 2
    int 21h
	ret

read_num: ; Ввод цифры, которая будет в DH
	mov ah, 1
	int 21h
	mov dh, al
	int 21h ; Ввод пробела
	
	sub dh, '0'
	ret

exit:
	mov ax, 4c00h
	int 21h

main:
	Menu_loop:
		call show_menu
		call read_num
		mov ax, 0
		mov al, dh
		mov si, ax
		add si, si

		push cx
		call Actions[si]
		pop cx

		loop Menu_loop


	mov ax, 4c00h
	int 21h
CSEG ENDS
END main