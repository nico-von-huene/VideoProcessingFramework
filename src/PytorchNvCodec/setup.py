from skbuild import setup
from torch.utils.cpp_extension import BuildExtension, CUDAExtension


if __name__ == "__main__":

    setup(
        name="PytorchNvCodec",
        version="2.0.0",
        install_requires=["torch==2.2.2+cu121", "torchvision==0.17.2+cu121", "wheel", "cmake>=3.21", "ninja; platform_system!='Windows'", "pkgconfig"],
        python_requires=">=3.10",
        ext_modules=[CUDAExtension("_PytorchNvCodec", ["src/PytorchNvCodec.cpp"])],
        packages=["PytorchNvCodec"],
        cmdclass={"build_ext": BuildExtension},
        # package_dir={"": ".."},
        # cmake_install_dir="..",
        # cmake_source_dir=".",
    )
