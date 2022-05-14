#include <iostream>
#include "slib.h"


int main()
{
    char src[] = "Hello World!";
    char dst[] = "01234567890123456789";


    std::cout << "Lenght = " << slen(src) << '\n';

    scpy(dst, src, slen(src));
    std::cout << dst;

    return 0;
}

