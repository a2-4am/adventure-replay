# https://sourceforge.net/projects/acme-crossass/
ACME=acme

# https://github.com/mach-kernel/cadius
CADIUS=cadius

BUILDDIR=build
SOURCES=$(wildcard src/*.a) $(wildcard ../common/src/*.a)
EXE=$(BUILDDIR)/LOADER.SYSTEM\#FF2000
DATA=$(wildcard ../common/res/*) $(wildcard res/*)
DISKVOLUME=COVETED.MIRROR
BUILDDISK=$(BUILDDIR)/$(DISKVOLUME).po

.PHONY: clean mount all

$(BUILDDISK): $(EXE) $(DATA)

$(EXE): $(SOURCES) | $(BUILDDIR)
	$(ACME) -r build/loader.lst src/loader.a
	$(CADIUS) REPLACEFILE "$(BUILDDISK)" "/$(DISKVOLUME)/" "$(EXE)" -C
	@touch "$@"

$(DATA): $(BUILDDIR)
	$(CADIUS) REPLACEFILE "$(BUILDDISK)" "/$(DISKVOLUME)/" "$@" -C
	@touch "$@"

mount: $(BUILDDISK)
	@open "$(BUILDDISK)"

clean:
	rm -rf "$(BUILDDIR)"

$(BUILDDIR):
	mkdir -p "$@"
	$(CADIUS) CREATEVOLUME "$(BUILDDISK)" "$(DISKVOLUME)" 800KB -C

all: clean mount

.NOTPARALLEL:
