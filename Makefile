

ARM := arm-none-eabi/bin/arm-none-eabi

LINKER := src/linker.ld
SOURCES := $(wildcard src/*)
SOURCES := $(filter-out $(LINKER), $(SOURCES))
OBJECTS := $(notdir $(SOURCES))
OBJECTS := $(OBJECTS:%.cpp=%.o)
OBJECTS := $(OBJECTS:%.c=%.o)
OBJECTS := $(OBJECTS:%.arm=%.o)
OBJECTS := $(addprefix obj/, $(OBJECTS))

all: folders bin/kernel.bin

folders:
	mkdir -p obj/ bin/

bin/kernel.bin: bin/kernel.elf
	$(ARM)-objcopy $^ -O binary $@

bin/kernel.elf: $(OBJECTS)
	$(ARM)-g++ -T$(LINKER) -ffreestanding -O2 -nostdlib $^ -o $@

obj/%.o: src/%.arm
	$(ARM)-as -mcpu=arm1176jzf-s $^ -o $@

obj/%.o: src/%.c
	$(ARM)-gcc -mcpu=arm1176jzf-s -fpic -ffreestanding -std=gnu99 -O2 -c $^ -o $@

obj/%.o: src/%.cpp
	$(ARM)-g++ -mcpu=arm1176jzf-s -fpic -ffreestanding -std=gnu++11 -O2 -fno-exceptions -fno-rtti -c $^ -o $@	

clean:
	rm -rf obj/ bin/