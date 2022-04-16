extern input: near
extern output_dec: near
extern N: word
public newline

SSEG SEGMENT para STACK 'STACK'
	db 100 dup(?)
SSEG ENDS

MSGS SEGMENT PARA PUBLIC 'DATA'

	Menu db 'Menu: ', 10
	db '0. Exit', 10
	db '1. Input number as signed in 2 c/c', 10
	db '2. Print number as unsigned in 16 c/c', 10
	db '3. Print number as signed in 10 c/c', 10, '$'
	Actions dw exit, input, output_dec;, out16
MSGS ENDS

CSEG SEGMENT para public 'CODE'
	assume CS:CSEG, DS:MSGS, SS:SSEG

show_menu:
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
	mov ax, MSGS
	mov ds, ax

	call show_menu

	call read_num
	mov ax, 0
	mov al, dh
	mov si, ax
	add si, si
	call Actions[si]

	;call input
	call output_dec


	mov ax, 4c00h
	int 21h
CSEG ENDS
END main