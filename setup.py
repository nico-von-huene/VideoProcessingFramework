if __name__ == "__main__":
    import skbuild

    PytorchNvCodec = "PytorchNvCodec @ git+https://github.com/nico-von-huene/VideoProcessingFramework.git#subdirectory=src/PytorchNvCodec/"
    skbuild.setup(
        name="PyNvCodec",
        version="2.0",
        description="Video Processing Library with full NVENC/NVDEC hardware acceleration",
        author="NVIDIA",
        license="Apache 2.0",
        install_requires=["numpy==1.24.4*"],
        extras_require={
            # , "PyOpenGL-accelerate" # does not compile on 3.10
            # "dev": ["pycuda", "pyopengl", "torch", "torchvision", "opencv-python", "onnx", "tensorrt", f"PytorchNvCodec @ file://{os.getcwd()}/src/PytorchNvCodec/"],
            "samples": ["pycuda", "pyopengl", "torch==2.2.0*", "torchvision==0.17.0*", "opencv-python", "onnx", "tensorrt", "tqdm", PytorchNvCodec],
            "tests": ["pycuda", "pyopengl", "torch==2.2.0*", "torchvision==0.17.0*", "opencv-python", PytorchNvCodec],
            "torch": ["torch==2.2.0*", "torchvision==0.17.0*", PytorchNvCodec],
            "tensorrt": ["torch==2.2.0*", "torchvision==0.17.0*", PytorchNvCodec],
        },
        dependency_links=[
            "https://pypi.ngc.nvidia.com"
        ],
        packages=["PyNvCodec"],
        package_data={"PyNvCodec": ["__init__.pyi"]},
        package_dir={"": "src"},
        cmake_install_dir="src",
    )
