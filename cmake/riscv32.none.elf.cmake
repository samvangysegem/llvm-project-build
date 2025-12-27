# CMake toolchain file for RISC-V firmware using LLVM/clang
# Target: CH32V30x development board
set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR riscv)

# Set the target triple
set(TARGET_TRIPLE "riscv32-none-elf")

# Compiler executables
set(CMAKE_C_COMPILER    "${TOOLCHAIN_PATH}/bin/clang")
set(CMAKE_CXX_COMPILER  "${TOOLCHAIN_PATH}/bin/clang++")
set(CMAKE_ASM_COMPILER  "${TOOLCHAIN_PATH}/bin/clang")
set(CMAKE_LINKER        "${TOOLCHAIN_PATH}/bin/ld.lld")
set(CMAKE_AR            "${TOOLCHAIN_PATH}/bin/llvm-ar")
set(CMAKE_RANLIB        "${TOOLCHAIN_PATH}/bin/llvm-ranlib")
set(CMAKE_OBJCOPY       "${TOOLCHAIN_PATH}/bin/llvm-objcopy")
set(CMAKE_OBJDUMP       "${TOOLCHAIN_PATH}/bin/llvm-objdump")
set(CMAKE_SIZE          "${TOOLCHAIN_PATH}/bin/llvm-size")
set(CMAKE_STRIP         "${TOOLCHAIN_PATH}/bin/llvm-strip")
set(CMAKE_READELF       "${TOOLCHAIN_PATH}/bin/llvm-readelf")

# Sysroot
set(CMAKE_SYSROOT       "${TOOLCHAIN_PATH}/riscv32-none-elf")

# Compiler and linker flags
set(CMAKE_ASM_FLAGS "-march=rv32imac_zicsr -mabi=ilp32")

set(CMAKE_C_FLAGS "${CMAKE_ASM_FLAGS}")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -ffunction-sections -fdata-sections") # Dedicated function and data sections (for garbage collection)
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -ffreestanding") # Enable freestanding environment
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fno-builtin") # Disable builtin functions
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -mno-relax") # Disable linker relaxation: larger/slower code but predictable sizes and deterministic builds
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -mcmodel=medany") # Medium memory model
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -msmall-data-limit=8") # Threshold for small data optimization (.sbss, .sdata)
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fno-pic -fno-pie") # Disable position-independent code

set(CMAKE_CXX_FLAGS "${CMAKE_C_FLAGS}")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fno-exceptions") # Disable exceptions
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fno-rtti") # Disable RTTI
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fno-use-cxa-atexit") # Disable calls to _cxa_atexit

set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -static") # Static linking
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -nostdlib") # Disable standard library linking
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -mno-relax") # Disable relaxation
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -fuse-ld=lld") # Use LLVM's lld linker
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -Wl,--gc-sections") # Garbage collect unused sections
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -Wl,-Map=${CMAKE_PROJECT_NAME}.map") # Generate map file

# Target-specific compiler options
set(CMAKE_C_COMPILER_TARGET ${TARGET_TRIPLE})
set(CMAKE_CXX_COMPILER_TARGET ${TARGET_TRIPLE})
set(CMAKE_ASM_COMPILER_TARGET ${TARGET_TRIPLE})

# Disable compiler checks
set(CMAKE_C_COMPILER_WORKS TRUE)
set(CMAKE_CXX_COMPILER_WORKS TRUE)
set(CMAKE_ASM_COMPILER_WORKS TRUE)

# Set output format to ELF
set(CMAKE_EXECUTABLE_SUFFIX ".elf")

# Warning flags
set(CMAKE_ASM_FLAGS "${CMAKE_ASM_FLAGS} -Wno-unused-command-line-argument")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall -Wextra -Wpedantic")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Wextra -Wpedantic")

# Debug flags
set(CMAKE_C_FLAGS_DEBUG "-g -O0")
set(CMAKE_CXX_FLAGS_DEBUG "-g -O0")
set(CMAKE_ASM_FLAGS_DEBUG "-g")

# Release flags
set(CMAKE_C_FLAGS_RELEASE "-O3 -DNDEBUG")
set(CMAKE_CXX_FLAGS_RELEASE "-O3 -DNDEBUG")
set(CMAKE_ASM_FLAGS_RELEASE "")

# MinSizeRel flags
set(CMAKE_C_FLAGS_MINSIZEREL "-Os -DNDEBUG")
set(CMAKE_CXX_FLAGS_MINSIZEREL "-Os -DNDEBUG")
set(CMAKE_ASM_FLAGS_MINSIZEREL "")

# RelWithDebInfo flags
set(CMAKE_C_FLAGS_RELWITHDEBINFO "-O2 -g -DNDEBUG")
set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "-O2 -g -DNDEBUG")
set(CMAKE_ASM_FLAGS_RELWITHDEBINFO "-g")
