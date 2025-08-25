# Use an official Python runtime as a parent image
FROM python:3.10-slim

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    build-essential \
    samtools \
    && rm -rf /var/lib/apt/lists/*

# Copy the AIVariant repository into the image
WORKDIR /opt/AIVariant
COPY . /opt/AIVariant

# Install Python dependencies
RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt

# Default command will run the main script
WORKDIR /opt/AIVariant/AIVariant
ENTRYPOINT ["python", "main.py"]
CMD ["--help"]
