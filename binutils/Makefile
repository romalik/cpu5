CC=gcc -O0 -g


all: cpu5as cpu5ld

#crt0.o: crt0.s
#	./cpu5as crt0.s crt0.o
	
#crt1.o: crt1.s
#	./cpu5as crt1.s crt1.o

#crt_end.o: crt_end.s
#	./cpu5as crt_end.s crt_end.o

cpu5as: asm.c labels.c token.c util.c sections.c
	$(CC) -o cpu5as asm.c labels.c token.c util.c sections.c

cpu5ld: link.c util.c labels.c sections.c
	$(CC) -o cpu5ld link.c util.c labels.c sections.c

install: all
	install -d /opt/cpu5/bin
	install -m 755 cpu5as /opt/cpu5/bin/
	install -m 755 cpu5ld /opt/cpu5/bin/
	install -d /opt/cpu5/lib
#	install -m 755 crt0.o /opt/cpu5/lib/
#	install -m 755 crt1.o /opt/cpu5/lib/
#	install -m 755 crt_end.o /opt/cpu5/lib/


clean:
	-rm cpu5as
	-rm cpu5ld
#	-rm crt0.o
#	-rm crt1.o
#	-rm crt_end.o
