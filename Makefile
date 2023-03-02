# Setting GOBIN makes 'go install' put the binary in the bin/ directory.
export GOBIN ?= $(dir $(abspath $(lastword $(MAKEFILE_LIST))))/bin

STITCHMD = bin/stitchmd

.PHONY: all
all: style.md

.PHONY: lint
lint:
	@DIFF=$$($(STITCHMD) -o style.md -d src/SUMMARY.md); \
	if [[ -n "$$DIFF" ]]; then \
		echo "style.md is out of date:"; \
		echo "$$DIFF"; \
		false; \
	fi

style.md: $(STITCHMD) $(wildcard src/*.md)
	$(STITCHMD) -o $@ src/SUMMARY.md

$(STITCHMD): tools/go.mod
	go install -C tools go.abhg.dev/stitchmd
