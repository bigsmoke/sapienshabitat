%.html : %.md
	pandoc $^ --standalone --data-dir=$(CURDIR)/layout/pandoc --template=sapienshabitat --to=html5 -o $@

%/meta.yaml : %/page.md
	pandoc $^ --standalone --data-dir=$(CURDIR)/layout/pandoc --template=yaml --to=markdown -o $@
