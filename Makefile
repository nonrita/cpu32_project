.PHONY: all sim clean help test-%

SIMULATOR = iverilog
VVPFLAGS = -v

# Automatically detect all source folders under src/
SRC_DIRS = $(wildcard src/*/)

# For each source directory, get all .v files and extract module names
# This creates a list of all modules across all subdirectories
MODULES = $(foreach dir,$(SRC_DIRS),$(basename $(notdir $(wildcard $(dir)*.v))))

# Helper function: find source file for a given module
# Search through all src subdirectories
find_src = $(wildcard src/*/$1.v)

# Default target
all: $(addprefix build/tb_,$(addsuffix .vvp,$(MODULES)))

# Pattern rule: Compile testbench for any module
build/tb_%.vvp: sim/tb_%.v
	@mkdir -p build
	$(SIMULATOR) -o $@ $^ $(call find_src,$*)

# Run all simulations
sim: $(addprefix build/tb_,$(addsuffix .vvp,$(MODULES)))
	@for module in $(MODULES); do \
		echo "========== Running $$module testbench =========="; \
		vvp build/tb_$$module.vvp; \
	done

# Run specific module test (e.g., make test-not, make test-and)
test-%: build/tb_%.vvp
	@echo "========== Testing $* module =========="
	vvp $<

# Clean build artifacts
clean:
	rm -rf build/*.vvp

# Help message
help:
	@echo "Available targets:"
	@echo "  all          - Build all testbenches ($(MODULES))"
	@echo "  sim          - Run all simulations"
	@echo "  test-MODULE  - Run specific module test (MODULE is the implementation file name)"
	@echo "  clean        - Remove build artifacts"
	@echo "  help         - Show this help message"
	@echo ""
	@echo "Available modules: $(MODULES)"
	@echo "Source directories: $(SRC_DIRS)"
	@echo ""
	@echo "Examples:"
	@echo "  make test-not - Compile and run tb_not.v (tests src/gates/not.v)"
	@echo "  make test-and - Compile and run tb_and.v (tests src/gates/and.v)"
	@echo "  make sim      - Run all tests sequentially"
