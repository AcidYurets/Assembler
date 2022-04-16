EXTRN INPUT_UH: NEAR				; ввод беззнакового в 16 с/c

EXTRN OUTPUT_UB: NEAR				; вывод беззнакового в 2 с/с

EXTRN OUTPUT_SO: NEAR

STACKSEG SEGMENT para STACK 'STACK'
	db 100 dup(?)
STACKSEG ENDS

DATASEG SEGMENT PARA PUBLIC 'DATA'
    MENU DB 'Available commands:', 10
         DB '1. Input unsigned hexadecimal number', 10
         DB '2. Convert to unsigned binary number', 10
         DB '3. Convert to signed octant number', 10
         DB '0. Quit program.', 10, 10
         DB 'Choose command: $'
    COMMANDS DW  EXIT, INPUT_UH, OUTPUT_UB, OUTPUT_SO
DATASEG ENDS

CODESEG SEGMENT PARA PUBLIC 'CODE'
    ASSUME CS:CODESEG, DS:DATASEG, SS:STACKSEG
	
OUTPUT_MENU PROC NEAR					; вывод меню
    mov AH, 9
    mov DX, OFFSET MENU
    int 21H
    ret
OUTPUT_MENU ENDP

EXIT PROC NEAR							; выход из программы
    mov AX, 4C00H
    int 21H
EXIT ENDP

INPUT_CMD PROC NEAR					; ввод номера команды в регистр SI
    mov AH, 1						; считать символ в al
    int 21H
    sub AL, '0'						; перевод в числовое значение
    mov CL, 2
    mul CL							; домножаем на 2 (размер команды 2 байта)
    mov SI, AX
    ret
INPUT_CMD ENDP

newline:
	mov DL, 10 ; возврат картеки и перевод на новую строку
    mov AH, 2
    int 21h
    mov DL, 13
    mov AH, 2
    int 21h
	ret

MAIN:
    mov AX, DATASEG
    mov DS, AX
	
    MAINLOOP:							; основной цикл
        call OUTPUT_MENU
        call INPUT_CMD
        call newline
		call COMMANDS[SI]
        jmp MAINLOOP

CODESEG ENDS
END MAIN