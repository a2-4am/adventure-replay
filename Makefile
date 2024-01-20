targets := \
	Masquerade \
	Fraktured-Faebles \
	Adventureland-v2.1-416 \
	Pirate-Adventure-v2.1-408 \
	Mission-Impossible-v2.1-306 \
	Voodoo-Island-v2.1-119 \
	The-Count-v2.1-115 \
	Strange-Odyssey-v2.1-119 \
	Sorcerer-of-Claymorgue-Castle-v2.2-122 \
	Questprobe-Spider-Man-vF-261 \
	Buckaroo-Banzai-vG-397

.PHONY: dsk all $(targets) package

dsk: $(targets)

# Build all targets
$(targets):
	@$(MAKE) -C $@

# Clean all temporary/target files
clean:
	@for dir in $(targets); do \
	  $(MAKE) -C $$dir clean; \
	done

all: clean $(targets)
