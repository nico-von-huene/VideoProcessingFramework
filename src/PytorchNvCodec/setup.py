from setuptools import setup
from torch.utils.cpp_extension import BuildExtension, CUDAExtension


if __name__ == "__main__":

    setup(
        name="PytorchNvCodec",
        install_requires=["torch>2.1,<2.3", "numpy>=1.24.4, <1.25.0"],
        ext_modules=[CUDAExtension("_PytorchNvCodec", ["src/PytorchNvCodec.cpp"])],
        packages=["PytorchNvCodec"],
        cmdclass={"build_ext": BuildExtension},
        package_dir={"": "../"},
        cmake_install_dir="../",
    )
