FROM nvidia/cuda:12.1.1-cudnn8-devel-ubuntu22.04 AS base

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
    python-is-python3 \
    python3-venv

ARG PIP_INSTALL_EXTRAS=""
# Build vpf
RUN mkdir /src
WORKDIR /src
COPY src src
COPY setup.py setup.py
COPY pyproject.toml pyproject.toml
COPY CMakeLists.txt CMakeLists.txt
RUN python3 -m venv venv
RUN venv/bin/python -m pip install --no-cache-dir setuptools wheel
RUN if [ -z "${PIP_INSTALL_EXTRAS}" ]; then \
       	venv/bin/python -m pip install -v --no-cache-dir . --extra-index-url https://download.pytorch.org/whl/cu121; \
    else \
       	venv/bin/python -m pip install -v --no-cache-dir .[$PIP_INSTALL_EXTRAS] --extra-index-url https://download.pytorch.org/whl/cu121; \
    fi
RUN venv/bin/python -c "import PyNvCodec"
SHELL ["/bin/bash", "-c"]
RUN if [[ "${PIP_INSTALL_EXTRAS}" = *"torch"* ]]; then \
		venv/bin/python -c "import PytorchNvCodec"; \
		venv/bin/python -c "import torch; assert torch.cuda.is_available()"; \
	fi


FROM base AS test

ARG PIP_INSTALL_EXTRAS=""
RUN mkdir /cwd
WORKDIR /cwd
COPY samples samples
RUN /src/venv/bin/python samples/SampleDemuxDecode2.py 0 "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4" test.yuv
SHELL ["/bin/bash", "-c"]
RUN if [[ "${PIP_INSTALL_EXTRAS}" = *"torch"* ]]; then \
		echo "Running PyTorch sample"; \
		/src/venv/bin/python samples/SamplePyTorch.py 0 "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4" test.mp4; \
    fi

ENTRYPOINT ["/bin/bash"]



FROM base AS wheel

ARG PIP_INSTALL_EXTRAS=""
RUN if [ -z "${PIP_INSTALL_EXTRAS}" ]; then \
        /src/venv/bin/python -m pip wheel -v --no-cache-dir . --extra-index-url https://download.pytorch.org/whl/cu121; \
    else \
        /src/venv/bin/python -m pip wheel -v --no-cache-dir .[$PIP_INSTALL_EXTRAS] --extra-index-url https://download.pytorch.org/whl/cu121; \
    fi
