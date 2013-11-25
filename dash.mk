DOCSET_NAME := $(shell echo $(DOCSET_NAME))
ifeq ($(DOCSET_NAME),)
$(error DOCSET_NAME is not set)
endif

# Setup
# from http://stackoverflow.com/q/4728810/465684
guard-%:
	@if [ "${${*}}" == "" ]; then \
		echo "Environment variable $* is not set"; \
		exit 1; \
	fi

DOCSET_DOCS_FOLDER := "$(DOCSET_NAME).docset/Contents/Resources/Documents"
DOCSET_SQL_DB := "$(DOCSET_NAME).docset/Contents/Resources/docset.dsidx"

# PHONY
.PHONY: install clean all prepublish publish docset help Makefile custom.mk

all: docset

install:
	@[ -d .git ] && git submodule update --init --recursive
	@npm install

clean:
	@rm -rf $(DOCSET_DOCS_FOLDER)/*
	@sqlite3 $(DOCSET_SQL_DB) "DROP TABLE IF EXISTS searchIndex;"

docset: guard-DOCSET_ID guard-DOCSET_VERSION guard-DOCSET_ENTRY_URL
	@DOCSET_NAME="$(DOCSET_NAME)" DOCSET_SQL_DB="$(DOCSET_SQL_DB)" DOCSET_DOCS_FOLDER="$(DOCSET_DOCS_FOLDER)" ./parseWrapper.coffee
	@DOCSET_NAME="$(DOCSET_NAME)" DOCSET_VERSION="$(DOCSET_VERSION)" DOCSET_VERSION_PKG="$(DOCSET_VERSION_PKG)" DOCSET_ENTRY_URL="$(DOCSET_ENTRY_URL)" ./feed.coffee > "$(DOCSET_NAME).xml"
	@DOCSET_NAME="$(DOCSET_NAME)" DOCSET_ID="$(DOCSET_ID)" ./Info.plist.coffee > "$(DOCSET_NAME).docset/Contents/Info.plist"

prepublish: clean all

publish:
	@npm publish

# From http://stackoverflow.com/a/15058900
help:
	@sh -c "($(MAKE) -f custom.mk -p Makefile; $(MAKE) -f .dash.mk/dash.mk -p Makefile) | awk -F':' '/^[a-zA-Z0-9][^\$$#\/\\t=]*:([^=]|$$)/ {split(\$$1,A,/ /);for(i in A)print A[i]}' | grep -v '__\$$' | grep -v 'Makefile' | grep -v 'custom.mk' | grep -v 'make' | sort | uniq"

Makefile:
	@:

custom.mk:
	@:
