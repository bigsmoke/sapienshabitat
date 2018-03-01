SHELL := /bin/bash

html5pages := $(patsubst pages/%/page.md,htdocs/%/page.html5,$(wildcard pages/*/page.md))
page_meta := $(patsubst pages/%/page.md,htdocs/%/meta.xml,$(wildcard pages/*/page.md))

SRC_IMAGES := $(wildcard pages/*/*.jpeg) $(wildcard pages/*/*.JPEG) $(wildcard pages/*/*.jpg) $(wildcard pages/*/*.JPG)
IMG_SOURCE = $(patsubst htdocs/%,pages/%,$1)
IMG_SCALED = $(join $(addsuffix img-$(2)w/,$(dir $(call IMG_COPIED,$1))),$(notdir $(call IMG_COPIED,$1)))
IMG_COPIED = $(patsubst pages/%,htdocs/%,$1)

define IMAGE_VARIANTS
COPIED_IMAGE = $(call IMG_COPIED,$(IMG_SOURCE))
all: $(COPIED_IMAGE)
$(COPIED_IMAGE): $(IMG_SOURCE)
	rm -f $$@
	ln --symbolic --relative $$< $$@

1000w_IMAGE = $(call IMG_SCALED,$(IMG_SOURCE),1000)
all: $(1000w_IMAGE)
$(1000w_IMAGE): $(IMG_SOURCE)
	convert -resize 1000 $$< $$@

500w_IMAGE = $(call IMG_SCALED,$(IMG_SOURCE),500)
all: $(500w_IMAGE)
$(500w_IMAGE): $(IMG_SOURCE)
	convert -resize 500 $$< $$@
endef

.SECONDEXPANSION:

$(foreach IMG_SOURCE,$(SRC_IMAGES),$(eval $(IMAGE_VARIANTS)))

all: $(html5pages) htdocs/page.html5 $(layout)

layout := htdocs/layout/style.css htdocs/layout/enhance.js htdocs/layout/Butterfly-vulcan-papillon-vulcain-vanessa-atalanta-2.png htdocs/layout/mushroom-2279552_1920.png htdocs/layout/soundcloud-icon.svg

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

taxonomies.xml: taxonomies.yaml
	cat $< | layout/yaml-to-json.py | layout/json-to-xml.py > $@

%/page.plain.html5 : %/page.md
	pandoc $< --standalone --data-dir=$(CURDIR)/layout/pandoc --template=sapienshabitat --from=markdown --to=html5 -o $@

# The site index lives in a subdirectory, but it also need to live in the document root.
htdocs/page.html5: htdocs/index/page.html5 htdocs/meta.xml
	rm --force $@  # Remove old symlink, in case it already exists
	ln --symbolic --relative $< $@

htdocs/%/page.html5 : pages/%/page.plain.html5 layout/add-layout.xsl
	mkdir -p $(dir $@)
	mkdir -p $(dir $@)img-1000w
	mkdir -p $(dir $@)img-500w
	xsltproc --stringparam slug "$(shell basename `dirname $<`)" layout/add-layout.xsl $< > $@

htdocs/meta.xml: $(page_meta)
	echo '<?xml version="1.0" ?>' > $@
	echo >> $@
	echo '<pages>' >> $@
	cat $^  \
		| sed -e 's/<root>/<page>/' \
		| sed -e 's/<\/root>/<\/page>/' \
		| sed -e '/^<?xml/d' >> $@
	echo '</pages>' >> $@

htdocs/%/meta.xml : pages/%/page.md
	pandoc $< --standalone --data-dir=$(CURDIR)/layout/pandoc --template=yaml --to=markdown \
		| sed -e '/^---/d' \
		| layout/yaml-to-json.py \
		| layout/merge-meta.py <(cat taxonomies.yaml | layout/yaml-to-json.py) \
		| layout/json-to-xml.py \
		| sed -e '/<root>/a<slug type="str">$*</slug>' > $@

htdocs/layout/% : layout/%
	mkdir -p htdocs/layout
	rm -f $@
	ln --symbolic --relative $< $@

htdocs/layout/style.css: layout/style.less layout/*.less
	lessc $< $@

.PHONY: all virtual clean
