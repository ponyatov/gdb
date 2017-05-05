TARGET = i486-elf

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
PFX = $(CWD)/$(TARGET)
ROOT = $(PFX).root
BUILD = $(CWD)/build

.PHONY: dirs
dirs:
	mkdir -p $(GZ) $(SRC) $(PFX) $(ROOT) $(BUILD)

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
CFG = configure --disable-nls \
	  --prefix=$(PFX) --target=$(TARGET) --with-sysroot=$(ROOT)

.PHONY: binutils
binutils: $(SRC)/$(BINUTILS)/README
	rm -rf $(BUILD)/$(BINUTILS) ; mkdir $(BUILD)/$(BINUTILS)
	cd $(BUILD)/$(BINUTILS) && $(SRC)/$(BINUTILS)/$(CFG)
	cd $(BUILD)/$(BINUTILS) && make && make install-strip

