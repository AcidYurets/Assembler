; .686
; .MODEL FLAT, C
; .STACK

; .CODE

; public scpy

; scpy:
;     push ebp
;     mov ebp, esp
; 	mov edi, [ebp + 8]
; 	mov esi, [ebp + 12]
;     mov edx, [ebp + 16]

;     mov ecx, edx ; Кладём длину источника в счётчик

;     cmp esi, edi ; Если источник лежит раньше приёмника,
;     jb  fwd      ; всё как у людей - прыгаем на fwd

; bwd:

;     add esi, ecx ; Смещаем начало источника
;     dec esi      ; на последний байт

;     add edi, ecx ; Смещаем начало приёмника
;     dec edi      ; на последний байт

;     std          ; В обратном направлении
;     rep movsb    ; побайтово копируем

;     pop ebp
;     ret

; fwd:

;     cld          ; В прямом направлении
;     rep movsb    ; побайтово копируем

;     pop ebp
;     ret

; END

.686
.model flat, c
.stack
.code

public scpy

scpy proc
    push ebp
    mov ebp, esp
 	mov edx, [ebp + 8]  ; dst
 	mov ecx, [ebp + 12] ; src
    mov eax, [ebp + 16] ; len

                ; my_strcpy(edx, ecx, eax)
    mov esi, ecx; ecx = src
    mov edi, edx; edx = dst
    mov ecx, eax; eax = len

    cmp edi, esi; src == dst ? quit : not_equal()
    je exit

not_equal : ; строки не перекрываются
    cmp edi, esi; edi < esi == dst < src
	jl copy

	mov eax, edi
	sub eax, esi

	cmp eax, ecx
	jge copy

complicated_copy : ; строки перекрываются
	add edi, ecx; смещаемся на длину и копируем с конца
	add esi, ecx
	sub esi, 1
	sub edi, 1
	std; df = 1

	copy:
    rep movsb; from esi to edi while df == 0  len == ecx раз
    cld; df = 0
exit:
    pop ebp
    ret
scpy endp

end