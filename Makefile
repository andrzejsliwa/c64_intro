# where the hell is 64tass?
TASS = $(shell which 64tass || echo ./64tass)
VICE = $(shell which x64 || echo /Applications/x64.app/Contents/MacOS/x64)
EXOMIZER = $(shell which exomizer || echo ./exomizer)
EXOMIZER_OPTIONS = sfx basic

# options, I need options!
TASS_OPTIONS = -a -C

build:
	@$(TASS) $(TASS_OPTIONS) source.asm -o output.prg -L output.deasm -l output.lbl
	#@$(EXOMIZER) $(EXOMIZER_OPTIONS) output.prg -n -o intro.prg

run: build
	killall x64 || true
	@$(VICE) -moncommands output.lbl intro.prg &
