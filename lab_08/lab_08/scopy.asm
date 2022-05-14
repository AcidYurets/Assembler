.686
.MODEL FLAT, C
.STACK

.CODE

public scpy

scpy:
    push ebp
    mov ebp, esp
	mov edi, [ebp + 8]
	mov esi, [ebp + 12]
    mov edx, [ebp + 16]

    mov ecx, edx ; Кладём длину источника в счётчик

    cmp esi, edi ; Если источник лежит раньше приёмника,
    jb  fwd      ; всё как у людей - прыгаем на fwd

bwd:

    add esi, ecx ; Смещаем начало источника
    dec esi      ; на последний байт

    add edi, ecx ; Смещаем начало приёмника
    dec edi      ; на последний байт

    std          ; В обратном направлении
    rep movsb    ; побайтово копируем

    pop ebp
    ret

fwd:

    cld          ; В прямом направлении
    rep movsb    ; побайтово копируем

    pop ebp
    ret

END