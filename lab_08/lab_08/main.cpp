#include <iostream>
#include "slib.h"


int main()
{
    char src[100] = "Hello World!";
    char dst[100] = "0123456789012345678";


    std::cout << "Lenght = " << slen(src) << '\n';

    scpy(dst, src, slen(src));
    std::cout << dst;

    return 0;  
}

