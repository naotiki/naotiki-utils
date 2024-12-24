FROM nvidia/cuda:12.6.2-devel-ubuntu24.04

WORKDIR /

# Select and pull from "https://catalog.ngc.nvidia.com/orgs/nvidia/containers/cuda".
# `base` does NOT include `nvcc` that is required to compile ffmpeg with nvcodec.

# The first one is necessary not to stop at installing git with time zone selection.
ENV DEBIAN_FRONTEND=noninteractive
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES video,compute,utility

# NVIDIA have not set these fundamental environment variables which most programs refer to
# while they selves are requiring in "https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html#mandatory-actions".
# An error about missing (not found) `nvcc` can raise without these setup.
ENV PATH="/usr/local/cuda-12.6/bin${PATH:+:${PATH}}"
ENV PKG_CONFIG_PATH="/usr/local/lib/pkgconfig${PKG_CONFIG_PATH:+:${PKG_CONFIG_PATH}}"
ENV LD_LIBRARY_PATH="/usr/local/cuda-12.6/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}"


# See "https://docs.nvidia.com/video-technologies/video-codec-sdk/12.0/ffmpeg-with-nvidia-gpu/index.html#compiling-for-linux".
# git, nasm and pkg-config are also required to install ffmpeg, however they are not included in above instruction.
# So they are added in following command.
RUN apt-get update \
  && apt-get install -y build-essential yasm cmake libtool libc6 libc6-dev unzip wget libnuma1 libnuma-dev git nasm pkg-config

# Check what version of Video Codec SDK is available with README in "https://github.com/FFmpeg/nv-codec-headers".
# Match the SDK and cuda.
# Ref) https://docs.nvidia.com/video-technologies/video-codec-sdk/12.2/read-me/index.html#system-requirements
RUN mkdir ffmpeg-nvcodec && cd ffmpeg-nvcodec \
  && git clone https://git.videolan.org/git/ffmpeg/nv-codec-headers.git \
  && cd nv-codec-headers && make && make install

RUN git clone https://git.ffmpeg.org/ffmpeg.git ffmpeg/

WORKDIR /ffmpeg
RUN  wget https://ffmpeg.org/releases/ffmpeg-7.1.tar.xz \
  && tar -xf ffmpeg-7.1.tar.xz \
  && rm ffmpeg-7.1.tar.xz

RUN apt install -y libvpx-dev

WORKDIR /ffmpeg/ffmpeg-7.1
RUN ./configure \
  --enable-nonfree --extra-cflags=-I/usr/local/cuda/include \
  --extra-ldflags=-L/usr/local/cuda/lib64 \
  --disable-static \
  --enable-shared \
  --enable-libnpp \
  --enable-cuda-nvcc \
  --enable-cuvid\
  --enable-nvdec \ 
  --enable-nvenc \ 
  --enable-libnpp\
  --enable-libvpx \ 
  && make -j $(nproc) \
  && make install

RUN echo 'export PATH=$PATH' >> ~/.bashrc \
  && echo 'export PKG_CONFIG_PATH=$PKG_CONFIG_PATH' >> ~/.bashrc \
  && echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH' >> ~/.bashrc

WORKDIR /work
