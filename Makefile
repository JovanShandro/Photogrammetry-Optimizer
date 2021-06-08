#!/usr/bin/env make -f
.POSIX:
.SUFFIXES:

all: help

.PHONY: help
help: ## Show this help (default)
	@egrep -h '\s##\s' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

.PHONY: install
install: ## Install project dependencies
	sudo apt install python3-pip
	pip3 install conan
	snap install mve
	snap install meshlab
	snap install ffmpeg
	sudo apt-get install -y gnuplot

.PHONY: build
build: create_dir conan_install ## Build executable from code
	cd build && cmake .. -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Release && cmake --build .

.PHONY: run
run: build ## Run executable 
	./build/bin/main $(COEFF)

.PHONY: reconstruct
reconstruct: ## Run necessary commands to perform reconstruction 
	./scripts/reconstruct.sh

.PHONY: measure
measure: ## Perform time measurements on reconstruction with different coefficients (0.1-0.9)
	./scripts/measure_time.sh

.PHONY: preview
preview: ## Open reconstructed 3D model if created with reconstruct target
	meshlab ./mve/scene/surface-l2-clean.ply

.PHONY: start
start: ## Run comparison step, perform reconstruction and view generated mesh
	$(MAKE) build
	$(MAKE) run
	$(MAKE) reconstruct
	$(MAKE) preview

.PHONY: create_dir
create_dir: 
	mkdir build || rm -fr build/*

.PHONY: conan_install
conan_install: 
	cd build && conan install ..

.PHONY: clean
clean: ## Remove build folder
	rm -fr build
