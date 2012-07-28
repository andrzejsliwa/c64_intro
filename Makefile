NAME= intro

BINARY_DIR= bin
SOURCE_DIR= src
BUILD_DIR= build
TOOLS_DIR= tools/catridges

# Assembler...
ASSEMBLER = \
	$(shell which tmpx || \
		echo $(BINARY_DIR)/tmpx)

# Emulator...
EMULATOR = \
	$(shell which x64 || \
		echo /Applications/x64.app/Contents/MacOS/x64)

# Disk creator...
DISK_CREATOR = \
	$(shell which c1541 || \
		echo $(BINARY_DIR)/c1541)

# Packer / compressor...
PACKER = \
	$(shell which exomizer || \
		echo $(BINARY_DIR)/exomizer)
PACKER_OPTIONS = sfx basic

CONVERTER = \
	$(shell which exomizer || \
		echo $(BINARY_DIR)/petcom)

all: clean diskimage

prepare:
	mkdir -p $(BUILD_DIR)

clean:
	rm -rf $(BUILD_DIR)

build: prepare
	$(ASSEMBLER) \
		-i $(SOURCE_DIR)/$(NAME).asm \
		-o $(BUILD_DIR)/output.prg \
		-l $(BUILD_DIR)/output.deasm
	$(PACKER) $(PACKER_OPTIONS) \
		$(BUILD_DIR)/output.prg \
			-n -o $(BUILD_DIR)/$(NAME).prg
	$(CONVERTER) - \
		$(SOURCE_DIR)/$(NAME).asm > \
		$(BUILD_DIR)/$(NAME).s

diskimage: build
	$(DISK_CREATOR) -format $(NAME),DF \
		d64 $(BUILD_DIR)/$(NAME).d64 \
			> /dev/null
	$(DISK_CREATOR) \
		-attach $(BUILD_DIR)/$(NAME).d64 \
		-write $(BUILD_DIR)/$(NAME).prg \
			$(NAME) \
		-write $(BUILD_DIR)/$(NAME).s \
			$(NAME).s

run: all
	killall x64  >/dev/null 2>&1 || true
	@$(EMULATOR) -reu -reusize 16384 -reuimage ./reuimage -cartrr $(TOOLS_DIR)/rr38p-tmp12.bin \
		$(BUILD_DIR)/$(NAME).d64:$(NAME)  >/dev/null 2>&1 &
	@echo "READY. ;)"
