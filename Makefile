targets := Masquerade Mission-Impossible-v2.1-306 Voodoo-Island-v2.1-119 The-Count-v2.1-115 Strange-Odyssey-v2.1-119 Sorcerer-of-Claymorgue-Castle-v2.2-122 Questprobe-Spider-Man-vF-261 Buckaroo-Banzai-vG-397

.PHONY: all $(targets) package

all: $(targets)

# Build all targets
$(targets):
	@$(MAKE) -C $@

# Clean all temporary/target files
clean:
	@for dir in $(targets); do \
	  $(MAKE) -C $$dir clean; \
	done
