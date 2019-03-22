CALABASH := calabash

all: repertorium.pdf edition.pdf

repertorium.pdf:
	$(CALABASH) -i source/repertorium.xml src/xproc/pipeline.xpl

edition.pdf:
	$(CALABASH) -i source/edition.xml src/xproc/pipeline.xpl

.PHONY: clean
clean:
	rm -f edition.pdf
	rm -f repertorium.pdf


