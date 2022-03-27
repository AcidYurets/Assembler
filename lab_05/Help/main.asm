EXTRN enter_mess: near
EXTRN mtrx_mess: near
EXTRN error_mess: near
EXTRN input_num: near
EXTRN output_num: near
EXTRN output_space: near
EXTRN output_ent: near
EXTRN zero_mass: near

STK SEGMENT PARA STACK 'STACK'
	db 200 dup(0)
STK ENDS

MTRX SEGMENT PARA PUBLIC 'DATA'
    m dw (0)
    n dw (0)
	matrix db 81 (0)
MTRX ENDS

DSEG SEGMENT PARA PUBLIC 'DATA'
	M_N_MESS db 'Enter M and N: ', 10, '$'
	MTX_MESS db 'Enter matrix: ', 10, '$'
    ERR_MESS db 10, 'ERR!', '$'
	NO_OUTPUT db 'NO OUTPUT!', '$'
DSEG ENDS

CSEG SEGMENT PARA PUBLIC 'CODE'
    assume CS:CSEG, DS:DSEG, ES:MTRX, SS:STK

input_matrix:
	call enter_mess
    call input_num
    mov m, ax
    
	call output_space

    call input_num
    mov n, ax
    
	call output_ent
	
	call mtrx_mess
    
	
	mov cx, m
    xor bx, bx
	
	inputMtx:
		call inputRow
		add bx, 9
		call output_ent
		loop inputMtx
	ret

inputRow:
	push (cx)
	mov cx, n
	xor si, si
	
	readElemLoop:
		call input_num
		mov matrix[bx][si], al
		inc si
		call output_space
		loop readElemLoop
		
	pop (cx)
	ret

find_max:
    xor di, di ;колонна для удаления
	xor si, si
	xor al, al ; сумма столбца
	xor dl, dl ; макс. сумма столбца
	
	mov cx, n
	sum:
		xor al, al
		call col_sum
		cmp dl, al
		jge skip_update
		
		mov dl, al
		mov di, si
		
		skip_update:
			inc si
		loop sum
	
	; удаление
	xor bx, bx
	mov cx, m
	delCol:
		call movRow
		add bx, 9
		loop delCol
		
	dec n
	ret

col_sum:
	xor bx, bx
	push (cx)
	mov cx, m
	columnSum:
		add al, matrix[bx][si]
		add bx, 9
		loop columnSum
	pop (cx)
	ret

movRow:
	mov si, di
	push (cx)
	
	mov cx, n
	dec cx
	sub cx, di
	cmp cx, 0
	jle skip
	movLoop:
		mov al, matrix[bx][si+1]
		mov matrix[bx][si], al
		inc si
		loop movLoop
	skip:
	pop (cx)
	ret

output_matrix:
	call output_ent
	
	;проверка пустоты вывода
	cmp n, 0
	je zero_mass
	
	mov cx, m
	xor bx, bx
	
	outputMtx:
		call outputRow
		add bx, 9
		call output_ent
		loop outputMtx
	ret

outputRow:
	xor si, si
	push (cx)
	mov cx, n
	
	output_elem:
		mov dl, matrix[bx][si]
		call output_num
		call output_space
		inc si
		loop output_elem
		
	pop (cx)
	ret

main:
	mov ax, DSEG
	mov ds, ax
    
	mov ax, MTRX
	mov es, ax

    call input_matrix
	
    call find_max 
    
	call output_matrix
    
    mov ah, 4Ch
    int 21h

CSEG ENDS

PUBLIC m
PUBLIC n
PUBLIC matrix

PUBLIC M_N_MESS
PUBLIC MTX_MESS
PUBLIC ERR_MESS
PUBLIC NO_OUTPUT
END main
