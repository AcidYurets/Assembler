#include "slib.h"

unsigned slen(const char* str) {
    unsigned int len = 0;

    __asm {
		push ecx;
		push edi;

		mov ecx, -1;
		mov edi, str;
		xor al, al;
		cld;
		repne scasb;
		not ecx;
		dec ecx;
		mov len, ecx;

		pop edi;
		pop ecx;
    };

    return len;
}
