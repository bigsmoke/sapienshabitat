html5pages := $(patsubst %/page.md,%/page.html5,$(wildcard pages/*/page.md))


all: $(html5pages)

virtual: 
	virtual/bin/activate

virtual/bin/activate: requirements.txt
	test -d virtual || virtualenv --python=python3 virtual
	virtual/bin/pip install -Ur requirements.txt
	touch virtual/bin/activate

taxonomies.xml: taxonomies.yaml layout/yaml-to-json.py layout/json-to-xml.py
	cat $< | layout/yaml-to-json.py | layout/json-to-xml.py > $@

%/page.plain.html5 : %/page.md
	pandoc $< --standalone --data-dir=$(CURDIR)/layout/pandoc --template=sapienshabitat --from=markdown --to=html5 -o $@

%/page.html5 : %/page.plain.html5 layout/add-layout.xsl taxonomies.xml
	xsltproc layout/add-layout.xsl $< > $@

%/meta.yaml : %/page.md
	pandoc $< --standalone --data-dir=$(CURDIR)/layout/pandoc --template=yaml --to=markdown -o $@

.PHONY: all virtual
