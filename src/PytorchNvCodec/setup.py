from skbuild import setup
from torch.utils.cpp_extension import BuildExtension, CUDAExtension


if __name__ == "__main__":

    setup(
        name="PytorchNvCodec",
        install_requires=["torch>=2.2.0a0,<2.2.1", "torchvision>=0.17.0a0,<0.17.1", "numpy==1.24.4", "wheel", "cmake>=3.21", "ninja; platform_system!='Windows'", "pkgconfig"],
        python_requires=">=3.10",
        ext_modules=[CUDAExtension("_PytorchNvCodec", ["src/PytorchNvCodec.cpp"])],
        packages=["PytorchNvCodec"],
        cmdclass={"build_ext": BuildExtension},
        package_dir={"": ".."},
        cmake_install_dir="..",
        cmake_source_dir="../..",
    )
