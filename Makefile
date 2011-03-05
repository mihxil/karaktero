
PDFLATEX=pdflatex
IMAGES=
DEPS=index.html Makefile ../latehxigu.xslt eo.sed  titolpag.tex revisio.tex $(IMAGES)
.PHONY: all clean deps images
all: karaktero-a4.pdf karaktero-a5.pdf karaktero-libreto.pdf


revisio.tex: .svn
	-svn up >/dev/null
	date  --rfc-3339=date | tr -d "\n" > revisio.tex
	svn info |  grep Revision | awk '{print " r" $$2}' >> revisio.tex



deps:

karaktero-a5.tex: $(DEPS)
	xsltproc -novalid ../latehxigu.xslt $<  | sed -f eo.sed -f ../utf8-tex.sed > $@

karaktero-a4.tex: $(DEPS)
	xsltproc -novalid  --stringparam geometry a4paper ../latehxigu.xslt $<  | sed -f eo.sed  -f ../utf8-tex.sed > $@

%.dvi: %.tex
	latex $<

%.signature.ps: %-a5.ps
	psbook -s8 $< $@

%.ps: %.dvi
	dvips $< -f > $@

%.eps: %.jpg
	convert $< $@


karaktero-libreto.ps:  karaktero.signature.ps
	psnup -d -l -pa4 -Pa5 -2  $< $@


%.pdf: %.ps
	ps2pdf $<

%.pdf: %.tex
	-$(PDFLATEX) $<


%.ps.gz: %.ps
	gzip -f $<


clean:
	rm -f *.pdf *.log *.aux *.dvi profitulo-a4*  *.ps profitulo-a5* *.eps