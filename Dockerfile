FROM nvidia/cuda:11.3.1-cudnn8-runtime-ubuntu20.04
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys A4B469963BF863CC
#更换为阿里源
RUN echo "deb http://mirrors.aliyun.com/ubuntu/ focal main restricted\n\
    deb http://mirrors.aliyun.com/ubuntu/ focal-updates main restricted\n\
    deb http://mirrors.aliyun.com/ubuntu/ focal universe\n\
    deb http://mirrors.aliyun.com/ubuntu/ focal-updates universe\n\
    deb http://mirrors.aliyun.com/ubuntu/ focal multiverse\n\
    deb http://mirrors.aliyun.com/ubuntu/ focal-updates multiverse\n\
    deb http://mirrors.aliyun.com/ubuntu/ focal-backports main restricted universe multiverse\n\
    deb http://mirrors.aliyun.com/ubuntu/ focal-security main restricted\n\
    deb http://mirrors.aliyun.com/ubuntu/ focal-security universe\n\
    deb http://mirrors.aliyun.com/ubuntu/ focal-security multiverse\n"\ > /etc/apt/sources.list
# 安装Python和pip
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get install -y wget
    # apt-get install -y python3.10 python3-pip git \
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
RUN bash Miniconda3-latest-Linux-x86_64.sh -b -p /opt/miniconda3
# RUN /opt/miniconda3/bin/conda init bash
#     source /opt/miniconda3/etc/profile.d/conda.sh

RUN rm Miniconda3-latest-Linux-x86_64.sh && \
    /opt/miniconda3/bin/conda init && \
    /opt/miniconda3/bin/conda update -n base -c defaults conda -y && \
    apt-get clean
    # rm -rf /var/lib/apt/lists/*

# 设置环境变量，确保 Miniconda 在 PATH 中可用
ENV PATH="/opt/miniconda3/bin:${PATH}"

RUN conda --version

WORKDIR /app
RUN apt-get install -y g++ cmake
ENV CONDA_DEFAULT_ENV panohead
COPY ./environment.yml /app
RUN conda config --set show_channel_urls yes && \  
    conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main/ && \  
    conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/ && \  
    conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/conda-forge/ && \  
    conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/msys2/ && \  
    conda clean --all -f -y  
RUN pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
RUN conda env create -f environment.yml

RUN apt clean & rm -rf /app & rm -rf ~/.cache/pip/*
ENV PYTHONPATH=/app:/app/llava

RUN echo "conda activate slab" >> ~/.bashrc && /bin/bash -c "source activate slab"
# SHELL ["/bin/bash", "-c"]