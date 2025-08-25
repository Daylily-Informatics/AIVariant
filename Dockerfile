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

# Create conda environments
RUN conda update -n base -y && \
    conda create -y -n input_env python=3.10 numpy pybigwig pysam liftover && \
    conda create -y -n eval_env python=3.10 numpy pybigwig pysam liftover tensorflow keras && \
    conda clean -afy

# Copy the AIVariant repository into the image
WORKDIR /opt/AIVariant
COPY . /opt/AIVariant
RUN chmod +x AIVariant/run.sh

# Default command will run the workflow script
WORKDIR /opt/AIVariant/AIVariant
ENTRYPOINT ["/opt/AIVariant/AIVariant/run.sh"]
