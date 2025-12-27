# CMake cache for building libc++ with picolibc for RISC-V32

# Python configuration - required for generating libcxx.imp
if(DEFINED ENV{PYENV_ROOT})
  set(Python3_EXECUTABLE "$ENV{PYENV_ROOT}/shims/python3" CACHE FILEPATH "")
endif()

# Library configuration
set(LIBCXX_ENABLE_SHARED OFF CACHE BOOL "")
set(LIBCXX_ENABLE_STATIC ON CACHE BOOL "")
set(LIBCXX_ENABLE_EXCEPTIONS OFF CACHE BOOL "")
set(LIBCXX_ENABLE_RTTI OFF CACHE BOOL "")
set(LIBCXX_ENABLE_THREADS OFF CACHE BOOL "")
set(LIBCXX_ENABLE_FILESYSTEM OFF CACHE BOOL "")
set(LIBCXX_ENABLE_LOCALIZATION OFF CACHE BOOL "")
set(LIBCXX_ENABLE_WIDE_CHARACTERS OFF CACHE BOOL "")
set(LIBCXX_ENABLE_MONOTONIC_CLOCK OFF CACHE BOOL "")
set(LIBCXX_ENABLE_RANDOM_DEVICE OFF CACHE BOOL "")
set(LIBCXX_CXX_ABI none CACHE STRING "")

# Work around CMake issue with shared/static library name conflicts
# See: https://gitlab.kitware.com/cmake/cmake/-/issues/25759
set(LIBCXX_SHARED_OUTPUT_NAME "c++-shared" CACHE STRING "")
