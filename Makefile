SHELL := /bin/bash

html5pages := $(patsubst pages/%/page.md,htdocs/%/page.html5,$(wildcard pages/*/page.md))
page_meta := $(wildcard pages/%/page.md,htdocs/%/meta.xml,$(wildcard pages/*/page.md))
src_images := $(wildcard pages/*/*.jpeg) $(wildcard pages/*/*.JPEG) $(wildcard pages/*/*.jpg) $(wildcard pages/*/*.JPG)
full_images := $(patsubst pages/%,htdocs/%,$(src_images))
img_1000w := $(join $(addsuffix img-1000w/,$(dir $(full_images))),$(notdir $(full_images)))
img_500w := $(join $(addsuffix img-500w/,$(dir $(full_images))),$(notdir $(full_images)))
layout := htdocs/layout/style.css htdocs/layout/Butterfly-vulcan-papillon-vulcain-vanessa-atalanta-2.png htdocs/layout/mushroom-2279552_1920.png

all: $(html5pages) $(full_images) $(img_1000w) $(img_500w) $(page_meta) $(layout) 

virtual: 
	virtual/bin/activate

virtual/bin/activate: requirements.txt
	test -d virtual || virtualenv --python=python3 virtual
	virtual/bin/pip install -Ur requirements.txt
	touch virtual/bin/activate

clean:
	cat .gitignore | xargs -I \{} echo rm \{}
	rm -rf htdocs/*

upload:
	rsync --verbose --copy-links --delete --recursive --times $(CURDIR)/htdocs/ bigsmoke_sapienshabitat@ssh.phx.nearlyfreespeech.net:/home/public/

%/page.plain.html5 : %/page.md
	pandoc $< --standalone --data-dir=$(CURDIR)/layout/pandoc --template=sapienshabitat --from=markdown --to=html5 -o $@

htdocs/%/page.html5 : pages/%/page.plain.html5 layout/add-layout.xsl taxonomies.xml
	mkdir -p $(dir $@)
	mkdir -p $(dir $@)img-1000w
	mkdir -p $(dir $@)img-500w
	xsltproc layout/add-layout.xsl $< > $@

%/meta.xml : %/page.md taxonomies.json
	pandoc $< --standalone --data-dir=$(CURDIR)/layout/pandoc --template=yaml --to=markdown \
		| sed -e '/^---/d' \
		| layout/yaml-to-json.py \
		| layout/merge-meta.py <(cat taxonomies.yaml | layout/yaml-to-json.py) \
		| layout/json-to-xml.py > $@

$(full_images) : htdocs/% : pages/%
	rm -f $@
	ln --symbolic --relative $< $@

htdocs/layout/% : layout/%
	mkdir -p htdocs/layout
	rm -f $@
	ln --symbolic --relative $< $@

htdocs/layout/style.css: layout/style.less layout/*.less
	lessc $< $@

$(img_1000w) : $(full_images)
	convert -resize 1000 $(subst img-1000w/,,$@) $@

$(img_500w) : $(full_images)
	convert -resize 500 $(subst img-500w/,,$@) $@

.PHONY: all virtual clean
