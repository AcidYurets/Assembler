#include <stdio.h>

#include "prec.h"

long double fsin_fldpi(long double x);

void line(long double p) {
    printf("PI = %Le, sin(PI / 1) = %Le, sin(PI / 2) = %Le;\n",
        p, fsin(p / 1), fsin(p / 2));
}

void line_fldpi() {
    printf("PI = %Le, sin(PI / 1) = %Le, sin(PI / 2) = %Le;\n",
        fldpi(), fsin_fldpi(1), fsin_fldpi(0.5));
}

/*int main() {
    line(PREC2PI);
    line(PREC6PI);
    line_fldpi();

    return 0;
}*/

long double fsin(long double x) {
    long double y;

    // Кладём на стек x, берём синус
    __asm{
        fld x
        fsin
        fstp y
    };

    return y;
}

long double fsin_fldpi(long double x) {
    long double y;

    // Кладём на стек x, берём синус
    __asm { 
        fld x
        fldpi
        fmulp ST(1), ST(0)
        fsin 
        fstp y
    };

    return y;
}

long double fldpi() {
    long double p;

    // Кладём на стек PI
    __asm { 
        fldpi
        fstp p
    };

    return p;
}
