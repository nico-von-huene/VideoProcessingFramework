# CUDA 12.8 and 13.1 fail to compile against glibc 2.42+ (rsqrt noexcept).
# GCC 15 is also outside those toolkits' supported host compilers.
#
# Apply before enable_language(CUDA) / project(... LANGUAGES CUDA) so the
# flags are used for CMake's CUDA compiler identification.

set(_VPF_CUDA_GLIBC_COMPAT_DIR "${CMAKE_CURRENT_LIST_DIR}/cuda_glibc_compat")

# nvcc --version -> e.g. 12.8 or 13.1. 0 if nvcc is not found.
macro(vpf_nvcc_release_version _out)
    set(_vpf_nvcc "")
    if(CMAKE_CUDA_COMPILER)
        set(_vpf_nvcc "${CMAKE_CUDA_COMPILER}")
    elseif(DEFINED ENV{CUDACXX} AND EXISTS "$ENV{CUDACXX}")
        set(_vpf_nvcc "$ENV{CUDACXX}")
    else()
        find_program(_vpf_nvcc NAMES nvcc
            HINTS ENV CUDA_HOME ENV CUDA_PATH
            PATH_SUFFIXES bin
            PATHS /usr/local/cuda/bin)
    endif()
    set(${_out} "0")
    if(_vpf_nvcc)
        execute_process(
            COMMAND "${_vpf_nvcc}" --version
            OUTPUT_VARIABLE _vpf_nvcc_out
            ERROR_VARIABLE _vpf_nvcc_err
            OUTPUT_STRIP_TRAILING_WHITESPACE
        )
        if(_vpf_nvcc_out MATCHES "release ([0-9]+\\.[0-9]+)")
            set(${_out} "${CMAKE_MATCH_1}")
        endif()
    endif()
endmacro()

# Fat-binary defaults. This does not probe the local GPU; pass
# -DCMAKE_CUDA_ARCHITECTURES=native (CMake 3.24+) for that.
# CUDA 13 dropped Maxwell/Pascal/Volta (sm_50–sm_72), including compute_60.
macro(vpf_set_default_cuda_architectures)
    vpf_nvcc_release_version(_vpf_cuda_rel)
    if(_vpf_cuda_rel VERSION_GREATER_EQUAL 13.0)
        # Turing+ and Blackwell consumer (sm_120). CUDA 13 dropped sm_50–sm_72.
        set(_vpf_cuda_arches 75 80 86 89 90 120)
    elseif(_vpf_cuda_rel VERSION_GREATER_EQUAL 12.8)
        set(_vpf_cuda_arches 70 75 80 86 89 90 120)
    else()
        set(_vpf_cuda_arches 60 70 72 75 80 86 89)
    endif()
    # Replace a cached Pascal-era list when nvcc can no longer build sm_60.
    if(NOT CMAKE_CUDA_ARCHITECTURES OR (
        _vpf_cuda_rel VERSION_GREATER_EQUAL 13.0 AND CMAKE_CUDA_ARCHITECTURES MATCHES "(^|;)60(;|$)"))
        set(CMAKE_CUDA_ARCHITECTURES ${_vpf_cuda_arches})
        message(STATUS "CMAKE_CUDA_ARCHITECTURES=${CMAKE_CUDA_ARCHITECTURES} (nvcc ${_vpf_cuda_rel})")
    endif()
endmacro()

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
