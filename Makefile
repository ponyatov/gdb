TARGET = i386-elf

BINUTILS_VER	= 2.28
GDB_VER			= 7.12.1

BINUTILS		= binutils-$(BINUTILS_VER)
GDB				= gdb-$(GDB_VER)

BINUTILS_GZ		= $(BINUTILS).tar.gz
GDB_GZ			= $(GDB).tar.gz

.PHONY: build
build: dirs gz binutils

CWD = $(CURDIR)
GZ = $(CWD)/gz
SRC = $(CWD)/src
PFX = $(CWD)/target
BUILD = $(CWD)/build

.PHONY: dirs
dirs:
	mkdir -p $(GZ) $(SRC) $(PFX) $(BUILD)

WGET = wget --no-check-certificate -c -P $(GZ)
.PHONY: gz
gz: $(GZ)/$(BINUTILS_GZ) $(GZ)/$(GDB_GZ)
$(GZ)/$(BINUTILS_GZ):
	$(WGET) http://ftp.gnu.org/gnu/binutils/$(BINUTILS_GZ)
$(GZ)/$(GDB_GZ):
	$(WGET) http://ftp.gnu.org/gnu/gdb/$(GDB_GZ)

$(SRC)/%/README: $(GZ)/%.tar.gz
	cd $(SRC) && tar zx < $< && touch $@

PFX = $(CURDIR)/$(TARGET)
CFG = echo configure --disable-nls --prefix=$(PFX)

.PHONY: binutils
binutils: $(SRC)/$(BINUTILS)/README
#	rm -rf build/$(BINUTILS) ; mkdir build/$(BINUTILS)
#	cd build/$(BINUTILS) ; ../src/$(BINUTILS)/$(CFG)

