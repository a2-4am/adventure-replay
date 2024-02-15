subtargets := \
	Masquerade \
	Fraktured-Faebles \
	Death-in-the-Caribbean \
	Adventureland-v2.1-416 \
	Pirate-Adventure-v2.1-408 \
	Mission-Impossible-v2.1-306 \
	Voodoo-Castle-v2.1-119 \
	The-Count-v2.1-115 \
	Strange-Odyssey-v2.1-119 \
	Sorcerer-of-Claymorgue-Castle-v2.2-122 \
	Questprobe-Spider-Man-vF-261 \
	Buckaroo-Banzai-vG-397 \
	Mystery-House \
	Cranston-Manor \
	The-Coveted-Mirror-1986 \
	Transylvania-1985

# https://github.com/mach-kernel/cadius
CADIUS=cadius

BUILDDIR=build
SOURCES=
EXE=
RES=$(wildcard res/*)
DISKVOLUME=ADVENTUREREPLAY
BUILDDISK=$(BUILDDIR)/$(DISKVOLUME).hdv
targets := \
	$(EXE) \
	$(RES)

.PHONY: all $(subtargets)

$(BUILDDISK): $(targets) | $(subtargets) $(BUILDDIR)
	@for dir in $(subtargets); do \
	  $(CADIUS) EXTRACTVOLUME $$dir/build/*.po "$(BUILDDIR)/X/"; \
	done
	rm -f $(BUILDDIR)/X/**/PRODOS* $(BUILDDIR)/X/**/_FileInformation.txt
# I refuse to use cadius ADDFOLDER command because it adds files in random order
# and I want them added in alphabetical order
	for dir in "$(BUILDDIR)/X/"*; do \
	  for f in "$$dir/"*; do \
	    $(CADIUS) REPLACEFILE "$(BUILDDISK)" "/$(DISKVOLUME)/X/$$(basename $$dir)/" "$$f" -C; \
	  done \
        done
	@touch "$@"

# Build all subtargets
$(subtargets):
	cd "$@" && make

$(EXE): $(SOURCES) | $(BUILDDIR)
#	$(ACME) -r build/loader.lst src/loader.a
#	$(CADIUS) REPLACEFILE "$(BUILDDISK)" "/$(DISKVOLUME)/" "$(EXE)" -C
#	@touch "$@"

$(RES): $(BUILDDIR)
	for f in "$@"/*; do \
	  $(CADIUS) REPLACEFILE "$(BUILDDISK)" "/$(DISKVOLUME)/$(notdir $@)" "$$f" -C; \
	done
	@touch "$@"

mount: $(BUILDDISK)
	@open "$(BUILDDISK)"

# Clean all temporary/target files
clean:
	rm -rf "$(BUILDDIR)"
	@for dir in $(subtargets); do \
	  $(MAKE) -C $$dir clean; \
	done

$(BUILDDIR):
	mkdir -p "$@"/X
	$(CADIUS) CREATEVOLUME "$(BUILDDISK)" "$(DISKVOLUME)" 32MB -C
	$(CADIUS) REPLACEFILE "$(BUILDDISK)" "/$(DISKVOLUME)/" common/res/PRODOS#FF2000 -C

all: clean $(subtargets)
