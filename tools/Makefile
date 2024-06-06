CC=gcc -O0 -g


all: cpu5mkfs

cpu5mkfs: mkfs.c
	$(CC) -o cpu5mkfs mkfs.c


install: all
	install -d /opt/cpu5/bin
	install -m 755 cpu5mkfs /opt/cpu5/bin/
	install -m 755 cpu5genfs /opt/cpu5/bin/


clean:
	-rm cpu5mkfs
