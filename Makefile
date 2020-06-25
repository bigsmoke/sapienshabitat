SHELL := /bin/bash

PLAIN_PAGES := $(wildcard pages/*/page.md)
HTML5_PAGES := $(patsubst pages/%/page.md,htdocs/%/page.html5,$(PLAIN_PAGES))
HTML5_INDEX := htdocs/page.html5
HTML5_STYLE := layout/add-layout.xsl
# The XSLT transformation includes the combined XML meta data extracted from all the pages (XML_PAGES_META)
# and the information about each taxonomy described in SRC_TAXON_YAML (through XML_TAXON_INCL).
XML_PAGES_META := $(patsubst pages/%/page.md,htdocs/%/meta.xml,$(PLAIN_PAGES))
XML_TAXON_META := htdocs/meta.xml  # The combined meta data for all the pages.
SRC_TAXON_YAML := taxonomies.yaml  # The actual file in which I maintain the taxonomies.
TMP_TAXON_JSON := taxonomies.json  # JSON is easier than YAML to convert to XML.
TMP_TAXON_XMLI := taxonomies.xml   # The XMLInclude that's loaded through the XSLT document() function.

SRC_IMAGES := $(wildcard pages/*/*.jpeg) $(wildcard pages/*/*.JPEG) $(wildcard pages/*/*.jpg) $(wildcard pages/*/*.JPG)
SRC_IMAGES := $(shell find pages/*/ -type f \( -iname "*.jpeg" -or -iname "*.jpg" \))
IMG_SOURCE = $(patsubst htdocs/%,pages/%,$1)
IMG_SCALED = $(join $(addsuffix img-$(2)w/,$(dir $(call IMG_COPIED,$1))),$(notdir $(call IMG_COPIED,$1)))
IMG_COPIED = $(patsubst pages/%,htdocs/%,$1)

layout := htdocs/layout/style.css \
	htdocs/layout/enhance.js \
	htdocs/layout/Butterfly-vulcan-papillon-vulcain-vanessa-atalanta-2.png \
	htdocs/layout/mushroom-2279552_1920.png \
	htdocs/layout/soundcloud-icon.svg

.PHONY: all
all: $(HTML5_PAGES) $(HTML5_INDEX) $(layout)

.SECONDEXPANSION:
# During the first expansion, when the below definition is eval-ed by the foreach,
# $< and $@ do not yet refer to sensible values. Therefore they are escaped with $$
# and not evaluated until the second expansion.
define IMAGE_VARIANTS =
$(call IMG_COPIED,$(IMG_SOURCE)): $(IMG_SOURCE)
	cp $$< $$@

$(call IMG_SCALED,$(IMG_SOURCE),1000): $(IMG_SOURCE)
	mkdir -p $$(dir $$@)
	convert -resize 1000 $$< $$@

$(call IMG_SCALED,$(IMG_SOURCE),500): $(IMG_SOURCE)
	mkdir -p $$(dir $$@)
	convert -resize 500 $$< $$@

all: $(call IMG_COPIED,$(IMG_SOURCE)) $(call IMG_SCALED,$(IMG_SOURCE),1000) $(call IMG_SCALED,$(IMG_SOURCE),500)
endef
# The IMAGE_VARIANTS definition will now be expanded for every file (IMG_SOURCE) in SRC_IMAGES.
$(foreach IMG_SOURCE,$(SRC_IMAGES),$(eval $(IMAGE_VARIANTS)))

.PHONY: virtual
#        | is followed by order-only prerequisites
virtual: | virtual/bin/activate virtual/bin/node
	@if [ -n "$(VIRTUAL_ENV)" ]; then \
		echo -n "$(shell tput setaf 1)$(shell tput bold)"; \
		echo -n "Virtual already activated."; \
		echo "$(shell tput sgr0)"; \
	else \
		source virtual/bin/activate; bash; \
	fi

virtual/bin/activate virtual/bin/python virtual/bin/python3 virtual/bin/nodeenv: requirements.txt
	test -d virtual || virtualenv --python=python3 virtual
	virtual/bin/pip install -Ur requirements.txt
	touch $@

virtual/bin/node virtual/bin/npm: virtual/bin/nodeenv
	test -x virtual/bin/node || virtual/bin/nodeenv -p

virtual/bin/lessc: virtual/bin/npm Makefile
	virtual/bin/node virtual/bin/npm install --global less@3.5.0
	touch $@

.PHONY: loop
loop:
	while true; do \
		make | ccze -A; inotifywait -r -e close_write *; sleep 0.1; \
	done

.PHONY: image_unspace
image_unspace:
	find . -name "*.jpg" | grep ' ' | rename 's/ /_/g'

.PHONY: clean
clean:
	# Nothing that is in the .gitignore is worth keeping.
	cat .gitignore | xargs -I \{} echo rm \{}
	# There should only be generated/copied stuff in htdocs. Get rid of it all.
	rm -rf htdocs/*

.PHONY: upload
upload:
	rsync --verbose --copy-links --delete --recursive --times \
		$(CURDIR)/htdocs/ sapienshabitat.com@bigpuff.tilaa.cloud:/srv/http/sapienshabitat.com/static/

.PHONY: list_drafts
list_drafts:
	find pages -name '*.md' | xargs grep -L 'published: '

.INTERMEDIATE:
$(TMP_TAXON_XMLI): $(TMP_TAXON_JSON) virtual/bin/python3 layout/json-to-xml.py
	cat $< | virtual/bin/python3 layout/json-to-xml.py > $@

.INTERMEDIATE:
$(TMP_TAXON_JSON): $(SRC_TAXON_YAML) virtual/bin/python3 layout/yaml-to-json.py
	cat $< | virtual/bin/python3 layout/yaml-to-json.py > $@

.INTERMEDIATE:
%/page.plain.html5 : %/page.md
	pandoc $< --standalone --data-dir=$(CURDIR)/layout/pandoc --template=sapienshabitat --from=markdown --to=html5 -o $@

# The site index lives in a subdirectory, but it also need to live in the document root.
$(HTML5_INDEX): htdocs/index/page.html5 $(XML_TAXON_META)
	cp $< $@

$(HTML5_STYLE): $(XML_TAXON_META) $(TMP_TAXON_XMLI)
	touch $@  # Just causing reverse dependants to be updated.

htdocs/%/page.html5 : pages/%/page.plain.html5 $(HTML5_STYLE)
	xsltproc --stringparam slug "$(shell basename `dirname $<`)" layout/add-layout.xsl $< > $@

.INTERMEDIATE:
$(XML_TAXON_META): $(XML_PAGES_META)
	# Combines all the meta information extracted from each page into a master meta file.
	echo '<?xml version="1.0" ?>' > $@
	echo >> $@
	echo '<pages>' >> $@
	cat $^  \
		| sed -e 's/<root>/<page>/' \
		| sed -e 's/<\/root>/<\/page>/' \
		| sed -e '/^<?xml/d' >> $@
	echo '</pages>' >> $@

htdocs/%/meta.xml : pages/%/page.md $(TMP_TAXON_JSON) virtual/bin/python3
	mkdir -p $(dir $@)
	# Extra the YAML headers from the Markdown page sources and
	# extend that information with the taxonomies information.
	pandoc $< --standalone --data-dir=$(CURDIR)/layout/pandoc --template=yaml --to=markdown \
		| sed -e '/^---/d' \
		| virtual/bin/python3 layout/yaml-to-json.py \
		| virtual/bin/python3 layout/merge-meta.py $(TMP_TAXON_JSON) \
		| virtual/bin/python3 layout/json-to-xml.py \
		| sed -e '/<root>/a<slug type="str">$*</slug>' > $@

htdocs/layout/% : layout/%
	# Most of the layout stuff, we can just copy.
	mkdir -p htdocs/layout
	cp $< $@

htdocs/layout/%.css: layout/%.less layout/*.less virtual/bin/lessc
	bash -c "source virtual/bin/activate && lessc $< $@"
