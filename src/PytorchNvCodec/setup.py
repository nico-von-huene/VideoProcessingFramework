import os
from pathlib import Path

from skbuild import setup
from torch.utils.cpp_extension import BuildExtension, CUDAExtension


def _cuda_glibc_compat_args():
    # Same overlay as cmake/VPFCudaCompat.cmake (CUDA 12.8/13.1 vs glibc 2.42+).
    compat = Path(__file__).resolve().parents[2] / "cmake" / "cuda_glibc_compat"
    if os.name == "nt" or not (compat / "bits" / "libc-header-start.h").is_file():
        return []
    return [f"-I{compat}"]


if __name__ == "__main__":
    _compat = _cuda_glibc_compat_args()

    setup(
        name="PytorchNvCodec",
        version="2.0.0",
        install_requires=["torch==2.7.0+cu128", "torchvision==0.22.0+cu128", "numpy>=1.24.4", "wheel", "cmake>=3.21,<4.0", "ninja; platform_system!='Windows'", "pkgconfig"],
        python_requires=">=3.10",
        ext_modules=[
            CUDAExtension(
                "_PytorchNvCodec",
                ["src/PytorchNvCodec.cpp"],
                extra_compile_args={"cxx": _compat, "nvcc": _compat},
            )
        ],
        packages=["PytorchNvCodec"],
        cmdclass={"build_ext": BuildExtension},
        # package_dir={"": ".."},
        # cmake_install_dir="..",
        # cmake_source_dir=".",
    )
