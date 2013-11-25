# Custom
-include custom.mk

# Default
.DEFAULT:
	@$(MAKE) -f .dash.mk/dash.mk $@
