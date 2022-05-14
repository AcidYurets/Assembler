#pragma once

unsigned slen(const char* str);

extern "C"
{
    void scpy(int, int, int);
    //void scpy(char* dst, const char* src, unsigned len); // подключение в код на Си/Си++ функции
    // на другом языке программирования,
    // выполненной в соответствии с соглашениями
    // о вызовах Си
}



