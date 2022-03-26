PUBLIC S
EXTRN output: near ; В пределах того же сегмента

SSEG SEGMENT PARA STACK 'STACK'
	db 100 dup (0)
SSEG ENDS

DSEG SEGMENT PARA PUBLIC 'DATA'
	S db 0ah
	db 100 dup (0)
DSEG ENDS

CSEG SEGMENT PARA PUBLIC 'CODE'
	assume CS:CSEG, DS:DSEG, SS:SSEG

input_str:
    mov cx, ax               ;Сохранение AX в CX
    mov ah, 0Ah              ;Функция DOS 0Ah - ввод строки в буфер
    mov [s], al              ;Запись максимальной длины в первый байт буфера
    mov [s+1], 0         ;Обнуление второго байта (фактической длины)
    mov dx, offset s         ;DX = aдрес буфера
    int 21h                  ;Обращение к функции DOS
    mov al, [s+1]            ;AL = длина введённой строки
    add dx, 2                ;DX = адрес строки
    mov ah, ch               ;Восстановление AH      
	ret

main:
	mov ax, DSEG
	mov ds, ax

	call input_str
	mov ah, 2
	mov dl, 13
	int 21h
	mov dl, 10
	int 21h
	
	call output

	mov ax, 4c00h
	int 21h
CSEG ENDS


END main