# CUDA 12.8 and 13.1 fail to compile against glibc 2.42+ (rsqrt noexcept).
# GCC 15 is also outside those toolkits' supported host compilers.
#
# Apply before enable_language(CUDA) / project(... LANGUAGES CUDA) so the
# flags are used for CMake's CUDA compiler identification.

set(_VPF_CUDA_GLIBC_COMPAT_DIR "${CMAKE_CURRENT_LIST_DIR}/cuda_glibc_compat")

macro(vpf_apply_cuda_compat)
    if(NOT VPF_CUDA_COMPAT_APPLIED)
        set(VPF_CUDA_COMPAT_APPLIED TRUE)

        if(UNIX AND NOT APPLE AND EXISTS "${_VPF_CUDA_GLIBC_COMPAT_DIR}/bits/libc-header-start.h")
            set(CMAKE_CUDA_FLAGS "${CMAKE_CUDA_FLAGS} -I${_VPF_CUDA_GLIBC_COMPAT_DIR}")
            set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -I${_VPF_CUDA_GLIBC_COMPAT_DIR}")
        endif()

        if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU" AND CMAKE_CXX_COMPILER_VERSION VERSION_GREATER_EQUAL 15)
            find_program(VPF_CUDA_HOST_CXX NAMES g++-14 g++-13)
            if(VPF_CUDA_HOST_CXX)
                set(CMAKE_CUDA_HOST_COMPILER "${VPF_CUDA_HOST_CXX}" CACHE FILEPATH
                    "nvcc host compiler; GCC 15 is unsupported by CUDA 12.8/13.1")
            endif()
        endif()
    endif()
endmacro()
