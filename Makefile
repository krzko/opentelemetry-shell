.SILENT:
.DEFAULT_GOAL := help

SHELL := /bin/bash
.SHELLFLAGS = -e

name := opentelemetry-shell
prefix ?= ~/.local
libdir ?= $(prefix)/lib/$(name)

##@ Install

.PHONY: install
install: ## Install OpenTelemetry Shell
ifeq ("$(wildcard $(libdir))", "")
		echo "Installing OpenTelemetry Shell..."
		mkdir -p $(libdir)
		cp -r library $(libdir)
		echo "Installed. Ensure you export your variables, eg:"
		echo "---"
		echo 'export OTEL_EXPORTER_OTEL_ENDPOINT="http://localhost:4318"'
		echo "export OTEL_SH_LIB_PATH=\"$(libdir)/library\""
else
	echo "OpenTelemetry Shell exists, overwriting..."
	rm -Rf $(libdir)
	mkdir -p $(libdir)
	cp -r library $(libdir)
	echo "Installed. Ensure you export your variables, eg:"
	echo "---"
	echo 'export OTEL_EXPORTER_OTEL_ENDPOINT="http://localhost:4318"'
	echo "export OTEL_SH_LIB_PATH=\"$(libdir)/library\""
endif

.PHONY: uninstall
uninstall: ## Uninstall OpenTelemetry Shell
ifeq ("$(wildcard $(libdir))", "")
	echo "$(libdir) does not exist. Skipping."
else
		echo "Uninstalling OpenTelemetry Shell..."
		rm -Rf $(libdir)
		echo "Uninstalled"
endif

##@ Operate

.PHONY: validate
validate: ## Validate OpenTelemetry Shell variables
ifndef OTEL_EXPORTER_OTEL_ENDPOINT
	echo "❌ export OTEL_EXPORTER_OTEL_ENDPOINT not set"
else
	echo "✅ OTEL_EXPORTER_OTEL_ENDPOINT found"
endif
ifndef OTEL_SH_LIB_PATH
	echo "❌ export OTEL_SH_LIB_PATH not set"
else
	echo "✅ OTEL_SH_LIB_PATH found"
endif

.PHONY: version
version: ## Show OpenTelemetry Shell
	. $(libdir)/library/otel_ver.sh; otel_sh_ver

.PHONY: _banner
_banner:
	printf " _____ _____ _____ _____ _____ _____ __    _____ _____ _____ _____ _____ __ __ \n"
	printf "|     |  _  |   __|   | |_   _|   __|  |  |   __|     |   __|_   _| __  |  |  |\n"
	printf "|  |  |   __|   __| | | | | | |   __|  |__|   __| | | |   __| | | |    -|_   _|\n"
	printf "|_____|__|  |_____|_|___| |_| |_____|_____|_____|_|_|_|_____| |_| |__|__| |_|  \n"
	printf " _____ _____ _____ __    __                                                    \n"
	printf "|   __|  |  |   __|  |  |  |                                                   \n"
	printf "|__   |     |   __|  |__|  |__                                                 \n"
	printf "|_____|__|__|_____|_____|_____|                                                \n"
	printf "\n"

##@ Help

.PHONY: help
help: _banner ## Display this help
	awk \
		'BEGIN { \
			FS = ":.*##"; printf "\033[37;1mUsage\n  \033[32;1mmake\033[0m \033[34;1m<target>\033[0m\n" \
		} /^[a-zA-Z_-]+:.*?##/ { \
			printf "  \033[34;1m%-15s\033[0m %s\n", $$1, $$2 \
		} /^##@/ { \
			printf "\n\033[37;1m%s\033[0m\n", substr($$0, 5) \
		}' $(MAKEFILE_LIST)
