# AIVariant Docker Image

This repository contains a `Dockerfile.aivariant` that builds an image with all
dependencies needed to run [AIVariant](https://github.com/Genome4me/AIVariant).

## Build the Image

```bash
docker build -f Dockerfile.aivariant -t aivariant:latest .
```

## Run AIVariant

After building, you can run the container and invoke `aivariant` directly:

```bash
docker run --rm aivariant:latest --help
```

This defaults to showing the command-line help for AIVariant. Replace
`--help` with the arguments required for your analysis.
