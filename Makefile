default: all


all: main.o
	ld main.o -o cat

run: all
	./cat

main.o: main.nasm
	nasm -felf64 main.nasm -o main.o

clean:
	@rm -f *.o cat
