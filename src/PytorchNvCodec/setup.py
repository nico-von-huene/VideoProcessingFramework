from setuptools import setup
from torch.utils.cpp_extension import BuildExtension, CUDAExtension


if __name__ == "__main__":

    setup(
        name="PytorchNvCodec",
        install_requires=["torch>1.10,<1.12", "numpy==1.22.4"],
        ext_modules=[CUDAExtension("_PytorchNvCodec", ["src/PytorchNvCodec.cpp"])],
        packages=["PytorchNvCodec"],
        cmdclass={"build_ext": BuildExtension},
        package_dir={"": "../"},
        cmake_install_dir="../",
    )
