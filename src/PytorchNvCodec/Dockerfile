FROM nvidia/cuda:12.1.1-cudnn8-devel-ubuntu22.04

ENV NVIDIA_DRIVER_CAPABILITIES=compute,video

RUN apt-get update && DEBIAN_FRONTEND=noninteractive \
    apt-get -y install \
    libavfilter-dev \
    libavformat-dev \
    libavcodec-dev \
    libswresample-dev \
    libavutil-dev\
    wget \
    build-essential \
    ninja-build \
    cmake \
    git \
    python3 \
    python3-pip \
    python-is-python3

RUN python3 -m pip install --no-cache-dir setuptools wheel
RUN ln -s /usr/local/cuda/lib64/stubs/libcuda.so /usr/local/cuda/lib64/stubs/libcuda.so.1
ENV LD_LIBRARY_PATH=/usr/local/cuda/lib64/stubs/:$LD_LIBRARY_PATH
# Build vpf
RUN mkdir /src
WORKDIR /src
COPY src src
COPY PytorchNvCodec PytorchNvCodec
COPY setup.py setup.py
COPY pyproject.toml pyproject.toml
RUN python3 -m pip install torch==2.2.2 torchvision==0.17.2 --index-url https://download.pytorch.org/whl/cu121
RUN python3 -m pip install -v --no-cache-dir .
RUN python3 -c "import PytorchNvCodec"

RUN mkdir /cwd
WORKDIR /cwd

ENTRYPOINT ["/bin/bash"]
