

all: alu_generator


alu_generator: alu_generator.c
	cc -o alu_generator alu_generator.c


install: all
	install -d /opt/cpu4/bin
	install -m 755 alu_generator /opt/cpu4/bin/

clean:
	-rm alu_generator

