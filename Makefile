html5pages := $(patsubst %/page.md,%/page.html5,$(wildcard pages/*/page.md))


all: $(html5pages)

%/page.plain.html5 : %/page.md
	pandoc $< --standalone --data-dir=$(CURDIR)/layout/pandoc --template=sapienshabitat --from=markdown --to=html5 -o $@

%/page.html5 : layout/add-layout.xsl %/page.plain.html5
	xsltproc $^ > $@

%/meta.yaml : %/page.md
	pandoc $< --standalone --data-dir=$(CURDIR)/layout/pandoc --template=yaml --to=markdown -o $@
