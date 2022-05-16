CC := gcc

CFLAGS := -std=gnu99

app.exe : main.o
	$(CC) -o $@ $^

main.o : main.c 
	$(CC) $(CFLAGS) -c -o main.o $<

.PHONY: clean
clean :
	rm *.o *.exe
