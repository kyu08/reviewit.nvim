.PHONY: lint format format-check test all setup

lint:
	luacheck lua/ plugin/ tests/

format:
	stylua lua/ plugin/ tests/

format-check:
	stylua --check lua/ plugin/ tests/

test:
	bash run_tests.sh

all: lint format-check test

setup:
	git config core.hooksPath .githooks
