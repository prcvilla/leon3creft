CC=sparc-elf-gcc
SIZE=sparc-elf-size
OBJCPY=sparc-elf-objcopy
OBJDMP=sparc-elf-objdump

CFLAGS=-msoft-float -Wall -lsmall
LDFLAGS=-qsvt -qnoambapp
DEFINES=-DBSIZE=20

TARGET=main
SOURCES=bubblesort.c testbubblesort.c main.c
OBJECTS=$(SOURCES:.c=.o)
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

dump: comp
	$(OBJDMP) -D $(TARGET).exe > $(TARGET).dump

size: comp
	$(SIZE) $(TARGET).exe

clean:
	rm -rf $(TARGET).exe *.o $(TARGET).dump
