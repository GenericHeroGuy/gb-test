NAME = gb-test
MKDIR = mkdir -p
ASM = wla-gb
ASMFLAGS = -q -I $(INCDIR)
LD = wlalink
LDFLAGS = -v -S -A
LINKFILE = linkfile

PNGCONVERT = superfamiconv tiles
CONVERTFLAGS = -v -M gb -D -p $(PNGDIR)/palette.json
CONVERTIN = -i
CONVERTOUT = -d

SRCDIR = src
INCDIR = inc
DEPDIR = dep
OBJDIR = obj
OUTDIR = out
CHRDIR = chr
PNGDIR = png

SRCS = $(wildcard $(SRCDIR)/*.asm)
OBJS = $(subst $(SRCDIR)/, $(OBJDIR)/, $(SRCS:.asm=.o))
DEPS = $(subst $(SRCDIR)/, $(DEPDIR)/, $(SRCS:.asm=.d))
PNGS = $(wildcard $(PNGDIR)/*.png)
CHRS = $(subst $(PNGDIR)/, $(CHRDIR)/, $(PNGS:.png=.chr))
BIN = $(OUTDIR)/$(NAME).gb

.PHONY: all clean

all: $(BIN)

$(DEPDIR)/%.d: $(SRCDIR)/%.asm
	@$(MKDIR) $(DEPDIR)
	$(ASM) $(ASMFLAGS) -M $< | sed 's,$(SRCDIR)/\($*\)\.o[ :]*,$(OBJDIR)/\1.o $@: ,g' > $@;

include $(DEPS)

$(CHRDIR)/%.chr: $(PNGDIR)/%.png
	$(PNGCONVERT) $(CONVERTFLAGS) $(CONVERTIN) $< $(CONVERTOUT) $@

$(OBJDIR)/%.o: $(SRCDIR)/%.asm
	@$(MKDIR) $(OBJDIR)
	$(ASM) $(ASMFLAGS) -o $@ $<

$(BIN): $(OBJS)
	@cp $(LINKFILE)_base $(LINKFILE)
	@echo '[objects]' >> $(LINKFILE)
	@for item in $(OBJS); do echo $$item >> $(LINKFILE); done
	$(LD) $(LDFLAGS) $(LINKFILE) $@

clean:
	rm $(OBJDIR)/* $(DEPDIR)/* $(CHRDIR)/* $(BIN)
