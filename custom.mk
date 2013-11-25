# DOCSET_NAME := "example"
# DOCSET_PARSER := "parse.coffee"
# DOCSET_ENTRY := "http://example.com/example.docset.tgz"

.PHONY: all

all:
	@$(MAKE) -f .dash.mk/dash.mk $@
