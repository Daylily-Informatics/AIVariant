FROM ubuntu:jammy

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    git \
    bzip2 \
    ca-certificates \
    build-essential \
    samtools \
    zlib1g-dev \
    curl \
    libcurl4-openssl-dev \
    && rm -rf /var/lib/apt/lists/*

# Copy the AIVariant repository into the image
WORKDIR /opt/AIVariant
COPY . /opt/AIVariant
RUN chmod +x AIVariant/run.sh

# Install Miniconda
RUN wget -q https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/miniconda.sh && \
    bash /tmp/miniconda.sh -b -p /opt/conda && \
    rm /tmp/miniconda.sh
ENV PATH=/opt/conda/bin:$PATH

# Create conda environments following project instructions
RUN conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/main && \
    conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/r && \
    conda install conda=25.7 && \
    conda env create -n input_env -f /opt/AIVariant/envs/input_env.yaml && \
    conda env create -n eval_env -f  /opt/AIVariant/envs/eval_env.yaml && \
    conda clean -afy


# Default command will run the workflow script
WORKDIR /opt/AIVariant/AIVariant
CMD ["/bin/bash"]
