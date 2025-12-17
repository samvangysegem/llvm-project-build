SHELL=/bin/zsh

# Constants
OUTPUT_DIR:=build.riscv
INSTALL_DIR:=$(abspath ./riscv-none-elf)

# Targets
all: clean install-riscv-none-elf

.PHONY: clean
clean:
	rm -rf ${OUTPUT_DIR}

.PHONY: config-riscv-none-elf
config-riscv-none-elf:
	-mkdir ${OUTPUT_DIR}
	cmake -DCMAKE_OSX_ARCHITECTURES=arm64 \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR} \
  -DLLVM_ENABLE_PROJECTS="clang;clang-tools-extra;lldb;lld" \
  -DLLVM_TARGETS_TO_BUILD="RISCV" \
  -DLLVM_CCACHE_BUILD=ON \
  -DLLVM_BUILD_TESTS=OFF \
  -DLLVM_INCLUDE_TESTS=OFF \
  -DLLDB_INCLUDE_TESTS=OFF \
  -Sllvm-project/llvm -GNinja -B${OUTPUT_DIR}

.PHONY: build-riscv-none-elf
build-riscv-none-elf: config-riscv-none-elf
	cmake --build ${OUTPUT_DIR}

.PHONY: install-riscv-none-elf
install-riscv-none-elf: build-riscv-none-elf
	cmake --build ${OUTPUT_DIR} --target install
