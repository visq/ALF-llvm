
TARGET = alf
BIBFILE = references

FIGURES  = $(patsubst %.eps,%.pdf,$(wildcard ./figures/*.eps))
TEXFILES = $(wildcard ./*.tex)

DICT = ./$(TARGET)_dict.pws

############
PDFLATEX = pdflatex -interaction=nonstopmode -halt-on-error
SHELL=/bin/bash
RED:=\e[31m
GREEN:=\e[32m
NOCOL:=\e[0m
############

.PHONY: all clean spell

all: $(TARGET)

.SUFFIXES:

$(TARGET): $(TARGET).pdf

$(TARGET).pdf: $(TEXFILES) $(BIBFILE).bib $(FIGURES)
	$(PDFLATEX) $(TARGET)
	bibtex $(TARGET)
	@while( $(PDFLATEX) $(TARGET); \
	  grep -q "Rerun" $(TARGET).log); do true; done
	@# get info about overfull boxes and warnings:
	@echo -e "$(NOCOL)\n== OVERFULL BOXES =============================$(RED)"
	@grep 'Overfull \\hbox' $(TARGET).log || echo -e "$(GREEN)No overfull hboxes."
	@echo -e "$(NOCOL)\n== LATEX WARNINGS =============================$(RED)"
	@grep 'LaTeX Warning' $(TARGET).log || echo -e "$(GREEN)No warnings."
	@echo -e "$(NOCOL)"


%.eps: %.dia
	dia -e $@ -t eps-pango $<

%.eps: %.dot
	dot -Teps $< > $@

%.pdf: %.eps
	epstopdf $<

spell: content.tex
	# use bash script for convenience
	./spellcheck.sh $(DICT) $^


again:
	$(PDFLATEX) $(TARGET)


clean:
	rm -fr $(TARGET).pdf $(FIGURES) *.aux *.log *.bbl *.out *.blg *.vtc
