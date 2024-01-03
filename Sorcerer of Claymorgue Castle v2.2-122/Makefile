# https://sourceforge.net/projects/acme-crossass/
ACME=acme

# https://github.com/mach-kernel/cadius
CADIUS=cadius

BUILDDIR=build
SOURCES=$(wildcard src/*.a) $(wildcard ../common/src/*.a)
EXE=$(BUILDDIR)/LOADER.SYSTEM\#FF2000
DATA=$(wildcard ../common/res/*) $(wildcard res/*)
DISKVOLUME=CLAYMORGUE
BUILDDISK=$(BUILDDIR)/saga13.po

.PHONY: clean mount all

$(BUILDDISK): $(EXE) $(DATA)

$(EXE): $(SOURCES) | $(BUILDDIR)
	$(ACME) -r build/loader.lst src/loader.a
	$(CADIUS) REPLACEFILE "$(BUILDDISK)" "/$(DISKVOLUME)/" "$(EXE)"
	@touch "$@"

$(DATA): $(BUILDDIR)
	$(CADIUS) REPLACEFILE "$(BUILDDISK)" "/$(DISKVOLUME)/" "$@"
	@touch "$@"

mount: $(BUILDDISK)
	@open "$(BUILDDISK)"

clean:
	rm -rf "$(BUILDDIR)"

$(BUILDDIR):
	mkdir -p "$@"
	$(CADIUS) CREATEVOLUME "$(BUILDDISK)" "$(DISKVOLUME)" 800KB

all: clean mount

.NOTPARALLEL:
