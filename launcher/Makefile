# https://sourceforge.net/projects/acme-crossass/
ACME=acme

SOURCES=$(wildcard src/*.a)
EXE=../build/LAUNCHER.SYSTEM\#FF2000
TEXTSOURCES=$(wildcard/src/gametext/*.a)
GAMETEXT=../build/GAMETEXT#060000

$(EXE): $(SOURCES) $(GAMETEXT)
	$(ACME) src/launcher.a

$(GAMETEXT): $(TEXTSOURCES)
	$(ACME) src/gametext/gametext.a
