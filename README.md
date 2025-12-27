# CH32V30x LLVM Toolchain

LLVM/Clang-based RISC-V toolchain for CH32V30x series boards.

## Components

- **LLVM 21.x** - Compiler infrastructure with RISC-V backend
- **picolibc** - Minimal C library for embedded systems
- **libc++** - LLVM's C++ standard library

## Requirements

- macOS (arm64)
- Python (pyenv-based)
- Ninja, CMake, Meson

## Build

```bash
make
```
