FROM nvidia/cuda:12.3.2-devel-ubuntu22.04

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

ARG PIP_INSTALL_EXTRAS=""
# Build vpf
RUN mkdir /src
WORKDIR /src
COPY src src
COPY setup.py setup.py
COPY pyproject.toml pyproject.toml
COPY CMakeLists.txt CMakeLists.txt
RUN python3 -m pip install --no-cache-dir setuptools wheel
RUN ln -s /usr/local/cuda/lib64/stubs/libcuda.so /usr/local/cuda/lib64/stubs/libcuda.so.1
ENV LD_LIBRARY_PATH=/usr/local/cuda/lib64/stubs/:$LD_LIBRARY_PATH
RUN if [ -z "${PIP_INSTALL_EXTRAS}" ]; then \
       	python3 -m pip install -v --no-cache-dir .; \
    else \
       	python3 -m pip install -v --no-cache-dir .[$PIP_INSTALL_EXTRAS]; \
    fi
RUN python3 -c "import PyNvCodec"
RUN if [ "${PIP_INSTALL_EXTRAS}" = *"torch"* ]; then \
		python3 -c "import PytorchNvCodec"; \
	fi
# RUN python3 -m pip wheel --no-cache-dir .[$PIP_INSTALL_EXTRAS]

RUN mkdir /cwd
WORKDIR /cwd

ENTRYPOINT ["/bin/bash"]
