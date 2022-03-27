;EXTRN m: byte
;EXTRN n: byte
;EXTRN matrix: byte
EXTRN M_N_MESS: word
EXTRN MTX_MESS: word
EXTRN ERR_MESS: word
EXTRN NO_OUTPUT: word
STK SEGMENT PARA STACK 'STACK'
	db 200 dup(0)
STK ENDS

CSEG SEGMENT PARA PUBLIC 'CODE'
    assume CS:CSEG, SS:STK

enter_mess:
	mov dx,OFFSET M_N_MESS
    mov ah,9
    int 21h
	ret
mtrx_mess:
	mov dx,OFFSET MTX_MESS
    mov ah,9
    int 21h
	ret
error_mess:
	mov dx,OFFSET ERR_MESS
    mov ah,9
    int 21h
	ret

input_num:
    mov ah, 1
    int 21h
	xor ah, ah				;?????
	cmp al,'1'              ;Если код символа меньше кода '0'
	jl studw_error          ; возвращаем ошибку
	cmp al,'9'              ;Если код символа больше кода '9'
	jg studw_error          ; возвращаем ошибку
		
    sub al, 30h
    ret

output_num:
    mov ah, 02h
    add dl, 30h
    int 21h
    ret
output_space:
    mov ah, 02h
    mov dl, ' '
    int 21h
    ret
output_ent:
    mov ah, 02h
    mov dl, 10
    int 21h
    ret

studw_error:
	call error_mess
    xor ax,ax               ;AX = 0
	mov ax, 4c00h
	int 21h 				;экстренное завершение
zero_mass:
	mov dx,OFFSET NO_OUTPUT
    mov ah,9
    int 21h
	xor ax,ax               ;AX = 0
	mov ax, 4c00h
	int 21h


CSEG ENDS

PUBLIC enter_mess
PUBLIC mtrx_mess
PUBLIC error_mess
PUBLIC input_num
PUBLIC output_num
PUBLIC output_space
PUBLIC output_ent
PUBLIC zero_mass
END
