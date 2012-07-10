NAME       = intro

# Directories
BINARY_DIR = bin
SOURCE_DIR = src
BUILD_DIR  = build

# TASS - turbo assembler
TASS             = \
	$(shell which 64tass || echo $(BINARY_DIR)/64tass)
TASS_OPTIONS     = -C

# Vice - emulator
VICE             = \
	$(shell which x64 || echo /Applications/x64.app/Contents/MacOS/x64)

# C1541 - disk creator
C1541            = \
	$(shell which c1541 || echo $(BINARY_DIR)/c1541)

# Exomizer - packer/compressor
EXOMIZER          = \
	$(shell which exomizer || echo $(BINARY_DIR)/exomizer)
EXOMIZER_OPTIONS = sfx basic

all: clean diskimage

prepare:
	mkdir -p $(BUILD_DIR)

clean:
	rm -rf $(BUILD_DIR)

build: prepare
	$(TASS) $(TASS_OPTIONS) $(SOURCE_DIR)/source.asm \
		-o $(BUILD_DIR)/output.prg \
		-L $(BUILD_DIR)/output.deasm \
		-l $(BUILD_DIR)/output.lbl
	$(EXOMIZER) $(EXOMIZER_OPTIONS) \
		$(BUILD_DIR)/output.prg \
		-n -o $(BUILD_DIR)/intro.prg

diskimage: build
	$(C1541) -format intro,DF  d64 $(BUILD_DIR)/intro.d64 > /dev/null
	$(C1541) \
		-attach $(BUILD_DIR)/intro.d64 \
		-write $(BUILD_DIR)/intro.prg intro

run: all
	killall x64 || true
	@$(VICE) -moncommands $(BUILD_DIR)/output.lbl $(BUILD_DIR)/intro.d64:intro &

