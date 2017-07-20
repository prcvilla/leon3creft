CC=sparc-elf-gcc
SIZE=sparc-elf-size
OBJCPY=sparc-elf-objcopy
OBJDMP=sparc-elf-objdump

CFLAGS=-msoft-float -Wall -O3
LDFLAGS=-qsvt -qnoambapp #-lsmall
DEFINES=

TARGET=main
SOURCES=main.c
OBJECTS=$(SOURCES:.c=.o)
DEST=../../designs/leon3-gr-xc3s-1500/
#target: dependecies
#(tab) commands
all: comp

#target for all objects, dependencies all sources
#this is what is called when the comp target is called
#note: $@ means the left part of the :, all the objects in this case
#      $^ means the right part of the :, all the C sources in this case
%.o: %.c
	$(CC) $(CFLAGS) $(DEFINES) -c -o $@ $^ $(LDFLAGS)


#link all objects into the executable
#this invoke each item in the $(OBJECTS) variable
comp: $(OBJECTS)
	$(CC) $(CFLAGS) $(DEFINES) -o $(TARGET).exe $^ $(LDFLAGS)

srec: comp
	$(SIZE) $(TARGET).exe
	$(OBJCPY) -O srec --gap-fill 0 $(TARGET).exe ram.srec

copy: srec
	cp ram.srec $(DEST)

dump: comp
	$(OBJDMP) -D $(TARGET).exe > $(TARGET).dump

clean:
	rm -rf $(TARGET).exe ram.srec *.o $(TARGET).dump
