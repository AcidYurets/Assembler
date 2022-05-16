#include <stdio.h>
#include <limits.h>
#include <time.h>
#define USE_FLOAT_80

void mesure_gnu_double(int times, double a, double b) 
{  
    clock_t start = clock();                           
    double res;                                         
    for (size_t i = 0; i < times; ++i) {              
      res = a + b;                                    
    }                                                 
    clock_t time_sum = clock() - start;               
                                                      
    start = clock();                                  
    for (size_t i = 0; i < times; ++i) {              
      res = a * b;                                    
    }                                                 
    clock_t time_mul = clock() - start;               
                                                      
    printf("Sum: %zu Mul: %zu\n", time_sum, time_mul);
}

void mesure_asm_double(int times, double a, double b) 
{  
    clock_t start = clock();                          
    double res;                                          
    for (size_t i = 0; i < times; ++i) {               
      asm("fld %1\n"                                   
          "fld %2\n"                                   
          "faddp\n"                                    
          "fstp %0\n"                                  
          : "=m"(res)                                  
          : "m"(a), "m"(b));                           
    }                                                  
    clock_t time_sum = clock() - start;                
                                                       
    start = clock();                                   
    for (size_t i = 0; i < times; ++i) {               
      asm("fld %1\n"                                   
          "fld %2\n"                                   
          "fmulp\n"                                    
          "fstp %0\n"                                  
          : "=m"(res)                                  
          : "m"(a), "m"(b));                           
    }                                                  
    clock_t time_mul = clock() - start;                
                                                       
    printf("Sum: %zu Mul: %zu\n", time_sum, time_mul); 
}

void mesure_gnu_float(int times, float a, float b) 
{  
    clock_t start = clock();                           
    float res;                                         
    for (size_t i = 0; i < times; ++i) {              
      res = a + b;                                    
    }                                                 
    clock_t time_sum = clock() - start;               
                                                      
    start = clock();                                  
    for (size_t i = 0; i < times; ++i) {              
      res = a * b;                                    
    }                                                 
    clock_t time_mul = clock() - start;               
                                                      
    printf("Sum: %zu Mul: %zu\n", time_sum, time_mul);
}

void mesure_asm_float(int times, float a, float b) 
{  
    clock_t start = clock();                          
    float res;                                          
    for (size_t i = 0; i < times; ++i) {               
      asm("fld %1\n"                                   
          "fld %2\n"                                   
          "faddp\n"                                    
          "fstp %0\n"                                  
          : "=m"(res)                                  
          : "m"(a), "m"(b));                           
    }                                                  
    clock_t time_sum = clock() - start;                
                                                       
    start = clock();                                   
    for (size_t i = 0; i < times; ++i) {               
      asm("fld %1\n"                                   
          "fld %2\n"                                   
          "fmulp\n"                                    
          "fstp %0\n"                                  
          : "=m"(res)                                  
          : "m"(a), "m"(b));                           
    }                                                  
    clock_t time_mul = clock() - start;                
                                                       
    printf("Sum: %zu Mul: %zu\n", time_sum, time_mul); 
}

void mesure_gnu__float80(int times, __float80 a, __float80 b) 
{  
    clock_t start = clock();                           
    __float80 res;                                         
    for (size_t i = 0; i < times; ++i) {              
      res = a + b;                                    
    }                                                 
    clock_t time_sum = clock() - start;               
                                                      
    start = clock();                                  
    for (size_t i = 0; i < times; ++i) {              
      res = a * b;                                    
    }                                                 
    clock_t time_mul = clock() - start;               
                                                      
    printf("Sum: %zu Mul: %zu\n", time_sum, time_mul);
}

void mesure_asm__float80(int times, __float80 a, __float80 b) 
{  
    clock_t start = clock();                          
    __float80 res;                                          
    for (size_t i = 0; i < times; ++i) {               
      asm("fld %1\n"                                   
          "fld %2\n"                                   
          "faddp\n"                                    
          "fstp %0\n"                                  
          : "=m"(res)                                  
          : "m"(a), "m"(b));                           
    }                                                  
    clock_t time_sum = clock() - start;                
                                                       
    start = clock();                                   
    for (size_t i = 0; i < times; ++i) {               
      asm("fld %1\n"                                   
          "fld %2\n"                                   
          "fmulp\n"                                    
          "fstp %0\n"                                  
          : "=m"(res)                                  
          : "m"(a), "m"(b));                           
    }                                                  
    clock_t time_mul = clock() - start;                
                                                       
    printf("Sum: %zu Mul: %zu\n", time_sum, time_mul); 
}

int main() {
  int times = 1e7;

  float a = 10.2, b = -234.3;
  printf("\nFloat\n");
  printf("GNU == ");
  mesure_gnu_float(times, a, b);
  printf("ASM == ");
  mesure_asm_float(times, a, b);

  printf("\nDouble\n");
  double c = 10.2, d = -234.3;
  printf("GNU == ");
  mesure_gnu_double(times, c, d);
  printf("ASM == ");
  mesure_asm_double(times, c, d);

  printf("\nLong double\n");
  __float80 e = 10.2, f = -234.3;
  printf("GNU == ");;
  mesure_gnu__float80(times, e, f);
  printf("ASM == ");
  mesure_asm__float80(times, e, f);
  return 0;
}