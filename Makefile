SOURCES := \
	Masquerade \
	Fraktured-Faebles \
	Death-in-the-Caribbean \
	Gruds-in-Space \
	Adventureland-v2.1-416 \
	Pirate-Adventure-v2.1-408 \
	Mission-Impossible-v2.1-306 \
	Voodoo-Castle-v2.1-119 \
	The-Count-v2.1-115 \
	Strange-Odyssey-v2.1-119 \
	Sorcerer-of-Claymorgue-Castle-v2.2-122 \
	Questprobe-The-Hulk-v2.3-127 \
	Buckaroo-Banzai-vG-397 \
	Mystery-House \
	Mission-Asteroid \
	Cranston-Manor \
	Transylvania-1985 \
	Crimson-Crown-1985 \
	Oo-Topos-1985 \
	The-Coveted-Mirror-1986

# https://github.com/mach-kernel/cadius
CADIUS=cadius

BUILDDIR=build
EXE=$(BUILDDIR)/LAUNCHER.SYSTEM\#FF2000
GAMETEXT=$(BUILDDIR)/GAMETEXT\#060000
GAMETITLES=$(BUILDDIR)/GAMETITLES\#060000
DISKVOLUME=ADVENTUREREPLAY
BUILDDISK=$(BUILDDIR)/$(DISKVOLUME).hdv
targets := \
	$(EXE) \
	$(GAMETITLES)

.PHONY: $(EXE) $(SOURCES)

$(BUILDDISK): $(targets) | $(SOURCES) $(BUILDDIR)
	@for dir in $(SOURCES); do \
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

# Build all games
$(SOURCES):
	cd "$@" && make

$(EXE): $(BUILDDIR)
	cd launcher/ && make
	$(CADIUS) REPLACEFILE "$(BUILDDISK)" "/$(DISKVOLUME)/" "$(EXE)" -C
	$(CADIUS) REPLACEFILE "$(BUILDDISK)" "/$(DISKVOLUME)/" "$(GAMETEXT)" -C

$(GAMETITLES): $(BUILDDIR)
	cat res/TITLE.HGR/REPLAY\#062000 > "$@" && \
	for f in $$(awk -F'"' '/^sVolume/ { print $$2 }' < launcher/src/db.games.a); do \
		cat res/TITLE.HGR/"$$f"\#062000 >> "$@"; \
	done
	$(CADIUS) REPLACEFILE "$(BUILDDISK)" "/$(DISKVOLUME)/" "$@" -C

mount: $(BUILDDISK)
	@open "$(BUILDDISK)"

# Clean all temporary/target files
clean:
	rm -rf "$(BUILDDIR)"
	@for dir in $(SOURCES); do \
	  $(MAKE) -C $$dir clean; \
	done

$(BUILDDIR):
	mkdir -p "$@"/X
	cp res/blank.hdv "$(BUILDDISK)"
	$(CADIUS) REPLACEFILE "$(BUILDDISK)" "/$(DISKVOLUME)/" common/res/PRODOS#FF2000 -C

launcher: $(EXE)
