from skbuild import setup
from torch.utils.cpp_extension import BuildExtension, CUDAExtension


if __name__ == "__main__":

    setup(
        name="PytorchNvCodec",
        version="2.0.0",
        install_requires=["torch==2.7.0+cu128", "torchvision==0.22.0+cu128", "numpy==1.26.4", "wheel", "cmake>=3.21,<4.0", "ninja; platform_system!='Windows'", "pkgconfig"],
        python_requires=">=3.10",
        ext_modules=[CUDAExtension("_PytorchNvCodec", ["src/PytorchNvCodec.cpp"])],
        packages=["PytorchNvCodec"],
        cmdclass={"build_ext": BuildExtension},
        # package_dir={"": ".."},
        # cmake_install_dir="..",
        # cmake_source_dir=".",
    )
