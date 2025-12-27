SHELL=/bin/zsh

# Build dirs
BUILD_DIR:=build
LLVM_BUILD_DIR:=${BUILD_DIR}/llvm-project
PICOLIBC_BUILD_DIR:=${BUILD_DIR}/picolibc
LIBCXX_BUILD_DIR:=${BUILD_DIR}/libcxx

# Install dirs
INSTALL_DIR:=$(abspath install)
LIBS_INSTALL_DIR:=$(abspath install/riscv32-none-elf)

# Targets
.PHONY: all clean config-llvm build-llvm install-llvm clean-llvm config-picolibc build-picolibc install-picolibc clean-picolibc config-libcxx build-libcxx install-libcxx clean-libcxx

# Default target
all: clean install-llvm install-picolibc install-libcxx

.PHONY: clean
clean:
	rm -rf ${BUILD_DIR} ${INSTALL_DIR}

######################
# LLVM - RISCV
######################

config-llvm:
	-@mkdir ${LLVM_BUILD_DIR}
	cmake -DCMAKE_OSX_ARCHITECTURES=arm64 \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR} \
    -DLLVM_ENABLE_PROJECTS="clang;clang-tools-extra;lldb;lld" \
    -DLLVM_TARGETS_TO_BUILD="RISCV" \
    -DLLVM_CCACHE_BUILD=ON \
    -DLLVM_BUILD_TESTS=OFF \
    -DLLVM_INCLUDE_TESTS=OFF \
    -DLLDB_INCLUDE_TESTS=OFF \
    -Sllvm-project/llvm -GNinja -B${LLVM_BUILD_DIR}

build-llvm: config-llvm
	cmake --build ${LLVM_BUILD_DIR}

install-llvm: build-llvm
	cmake --build ${LLVM_BUILD_DIR} --target install

clean-llvm:
	@rm -rf $(LLVM_BUILD_DIR)

######################
# PICOLIBC
######################

PICOLIBC_SOURCE_DIR := $(abspath picolibc)
PICOLIBC_CROSS_FILE_TEMPLATE := meson/picolibc.cross.ini.in
PICOLIBC_CROSS_FILE := $(abspath $(PICOLIBC_BUILD_DIR)/picolibc.cross.ini)

$(PICOLIBC_CROSS_FILE): $(PICOLIBC_CROSS_FILE_TEMPLATE)
	-@mkdir -p $(PICOLIBC_BUILD_DIR)
	@echo "Generating cross-file: $(CROSS_FILE)"
	@sed -e 's|@TOOLCHAIN_PATH@|$(INSTALL_DIR)|g' \
    $(PICOLIBC_CROSS_FILE_TEMPLATE) > $(PICOLIBC_CROSS_FILE)

# When multilib disabled, arch and abi need to be added to
# compile args in cross file
# When multilib enabled, args are provided through compiler:
# `clang -target riscv32-none-elf --print-multi-lib`
config-picolibc: $(PICOLIBC_CROSS_FILE)
	cd $(PICOLIBC_BUILD_DIR) && \
  meson setup --cross-file $(PICOLIBC_CROSS_FILE) \
    --prefix=$(LIBS_INSTALL_DIR) \
    -Dmultilib=false \
    -Dtests=false \
    -Dpicocrt=false \
    -Ddebug=false \
    $(PICOLIBC_SOURCE_DIR)

build-picolibc: config-picolibc
	cd $(PICOLIBC_BUILD_DIR) && ninja

install-picolibc: build-picolibc
	cd $(PICOLIBC_BUILD_DIR) && ninja install

clean-picolibc:
	@rm -rf $(PICOLIBC_BUILD_DIR)

######################
# LLVM - LIBCXX
######################

LIBCXX_TOOLCHAIN_FILE:=$(abspath cmake/riscv32.none.elf.cmake)
LIBCXX_CACHE_FILE:=$(abspath cmake/libcxx.cmake)

config-libcxx:
	-@mkdir ${LIBCXX_BUILD_DIR}
	cmake -Sllvm-project/libcxx -GNinja -B${LIBCXX_BUILD_DIR} \
    -C$(LIBCXX_CACHE_FILE) \
    --toolchain $(LIBCXX_TOOLCHAIN_FILE) \
    -DTOOLCHAIN_PATH=$(INSTALL_DIR) \
    -UCMAKE_OSX_ARCHITECTURES \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=${LIBS_INSTALL_DIR}

build-libcxx: config-libcxx
	cmake --build ${LIBCXX_BUILD_DIR}

install-libcxx: build-libcxx
	cmake --build ${LIBCXX_BUILD_DIR} --target install

clean-libcxx:
	@rm -rf $(LIBCXX_BUILD_DIR)
