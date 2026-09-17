/*
 * CUDA 12.8 / 13.1 vs glibc 2.42+ (rsqrt / rsqrtf noexcept).
 *
 * glibc 2.42 declares rsqrt() / rsqrtf() as noexcept(true) when
 * IEC 60559 C23 extras are enabled (_GNU_SOURCE does that). CUDA 12.8 and
 * 13.1 declare the same names in crt/math_functions.h without noexcept, so
 * nvcc fails during compiler identification. CUDA 13.2 matches glibc.
 *
 * This wrapper is found first via -I and turns those extras off after the
 * real header runs. Older glibc has no rsqrt in math.h, so this is a no-op.
 */
#include_next <bits/libc-header-start.h>
#undef __GLIBC_USE_IEC_60559_FUNCS_EXT_C23
#define __GLIBC_USE_IEC_60559_FUNCS_EXT_C23 0
