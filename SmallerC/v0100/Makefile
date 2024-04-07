CC=gcc -O0 -g


all: smlrc


smlrc: smlrc.c
	$(CC) -o smlrc smlrc.c


install: all
	install -d /opt/cpu5/bin
	install -m 755 smlrc /opt/cpu5/bin/


clean:
	-rm smlrc
