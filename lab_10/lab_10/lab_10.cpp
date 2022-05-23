#include <iostream>

#include <stdio.h>

// Профилирование
#include <time.h>

// Проверка условий
#include <assert.h>

// Число повторов
#define LOOP 1e+8

float sdprod(float* u, float* v) {

    // Очень дёшево и очень сердито, как по учебнику
    return u[0] * v[0] + u[1] * v[1] + u[2] * v[2] + u[3] * v[3];
}

float fdprod(float* u, float* v) {
    std::cout << u << " " << v << std::endl;
    float p = 0;

    __asm {
        movups     xmm0, u        // Кладём u в xmm0
        movups     xmm1, v        // Кладём v в xmm1
        mulps      xmm0, xmm1     // Домножаем u на v
        movhlps    xmm1, xmm0     // Кладём старшую пару элементов
        addps      xmm0, xmm1     // произведения в v и складываем
        movups     xmm1, xmm0     // Копируем частичную сумму в v
        shufps     xmm0, xmm0, 1  // Кладём второй элемент в первый
        addps      xmm0, xmm1     // Складываем с исходным первым
        movss      p, xmm0
    };

    return p;
}

void line(const char* f, clock_t s, clock_t t) {
    printf("%s: %e s\n", f,
        (double)(t - s) / CLOCKS_PER_SEC / LOOP);
}

int main() {
    float u[4] = { 1, 2, 3, 4 };
    float v[4] = { 1, 2, 4, 8 };

    clock_t s, t;

    /* Профилирование простой реализации */ {
        s = clock();

        for (int i = 0; i < LOOP; i++)
            assert(sdprod(u, v) == 49);

        t = clock();

        line("sdprod", s, t);
    }

    /* Профилирование быстрой реализации */ {
        s = clock();

        for (int i = 0; i < LOOP; i++)
        {
            std::cout << fdprod(u, v) << std::endl;
            assert(fdprod(u, v) == 49);
        }

        t = clock();

        line("fdprod", s, t);
    }

    return 0;
}

