FROM ubuntu:22.04

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    git \
    bzip2 \
    ca-certificates \
    build-essential \
    samtools \
    && rm -rf /var/lib/apt/lists/*

# Install Miniconda
RUN wget -q https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/miniconda.sh && \
    bash /tmp/miniconda.sh -b -p /opt/conda && \
    rm /tmp/miniconda.sh
ENV PATH=/opt/conda/bin:$PATH

# Create conda environments following project instructions
RUN conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/main && \
    conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/r && \
    conda create -y -n input_env && \
    conda install -n input_env -y python=3.6.9 numpy -c conda-forge && \
    conda install -n input_env -y -c bioconda samtools pysam  pyBigWig liftover && \
    conda create -y -n eval_env && \
    /opt/conda/envs/eval_env/bin/pip install 'tensorflow>=2.9' && \
    conda clean -afy

# Copy the AIVariant repository into the image
WORKDIR /opt/AIVariant
COPY . /opt/AIVariant
RUN chmod +x AIVariant/run.sh

# Default command will run the workflow script
WORKDIR /opt/AIVariant/AIVariant
ENTRYPOINT ["/opt/AIVariant/AIVariant/run.sh"]
