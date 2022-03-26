SD1 SEGMENT para common 'DATA' ; Тоже накладывается
	C1 LABEL byte ; D
	ORG 1h
	C2 LABEL byte ; 4
SD1 ENDS

CSEG SEGMENT para 'CODE'
	ASSUME CS:CSEG, DS:SD1
main:
	mov ax, SD1
	mov ds, ax
	mov ah, 2
	mov dl, C1 ; D
	int 21h
	mov dl, C2 ; 4
	int 21h
	mov ax, 4c00h
	int 21h
CSEG ENDS
END main