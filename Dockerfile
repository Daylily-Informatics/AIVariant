# Use an official Python runtime as a parent image
FROM python:3.10-slim

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Clone the AIVariant repository
RUN git clone https://github.com/Genome4me/AIVariant /opt/AIVariant

# Install Python dependencies
WORKDIR /opt/AIVariant
RUN pip install --no-cache-dir --upgrade pip \
    && if [ -f requirements.txt ]; then pip install --no-cache-dir -r requirements.txt || true; fi

# Default command will run the main script
WORKDIR /opt/AIVariant/AIVariant
ENTRYPOINT ["python", "main.py"]
CMD ["--help"]