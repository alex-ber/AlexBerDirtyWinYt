FROM alexberkovich/ubuntu2404-snapshot:2025-06-16


#[HARDWARE_CONFIG]: Deterministic execution and compilation flags
# Consolidated environment variables to reduce layer allocation overhead.
ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1 \
    LANG=C.UTF-8 \
    PYTHONDONTWRITEBYTECODE=1 \
    UV_CACHE_DIR=/tmp/.uv-cache \
    UV_COMPILE_BYTECODE=1 \
    UV_LINK_MODE=copy \
    UV_PYTHON_INSTALL_DIR=/opt/python

WORKDIR /app


#[HARDWARE_BRIDGE]: Injecting UV Compiler (AOT Dependency Graph Resolver)
COPY --from=ghcr.io/astral-sh/uv@sha256:ff07b86af50d4d9391d9daf4ff89ce427bc544f9aae87057e69a1cc0aa369946 /uv /uvx /bin/


#[RUNTIME_ENVIRONMENT]: Deterministic APT Projection & Root Python Allocation
RUN set -ex && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        nano \
        ffmpeg \
    && rm -rf /var/lib/apt/lists/* \
    # STRICT LOCK: TOML requires >=3.11, <=3.12 (Crucial for torch 2.12.0 + cu130 compatibility)
    && uv python install 3.12.3





#[DEPENDENCY_INJECTION]: Top-Down Directed Acyclic Graph Mount
COPY pyproject.toml uv.lock ./

#[POINTER_ALLOCATION]: Synthetic Mock-Node Cache Strategy
# Bypasses hatchling early parse exception, isolating dependency layer from source layer jitter.
RUN set -ex && \
    mkdir -p src/neural_extractor_node && \
    echo '__version__ = "0.1.3"' > src/neural_extractor_node/__init__.py && \
    uv sync --no-install-project

#[AST_COPY]: Mount Root Logic
COPY src/ src/

#[PROJECT_INJECTION]: Finalize Symbol Table Linkage
RUN set -ex && \
    uv sync && \
    chmod -R 777 /app/.venv && \
    chmod -R 755 /opt/python

#[ENTRYPOINT]: Hardware Transition (Main Thread Execution)
CMD ["uv", "run", "python", "-m", "src.neural_extractor_node.transcribe"]
##CMD ["sleep", "infinity"]

#mise prune
#mise install
# ---[STATELESS BIRUR DAEMON] ---
# To regenerate uv.lock WITHOUT installing uv on the Host OS, run this ephemeral hypervisor:
# docker run --rm -v "$(pwd):/app" -w /app ghcr.io/astral-sh/uv:python3.12-bookworm-slim uv lock

#If only source code was changed
#docker build --progress=plain -t neural-extractor-node-i .

#docker build --no-cache --progress=plain -t neural-extractor-node-i .
# Note: Added `--gpus all` to mount the RTX 4060 Ti / CUDA 13.0 toolkit bridge
#docker run -it --gpus all -v "$(pwd)/src/neural_extractor_node:/app/data" neural-extractor-node-i
# The --entrypoint /bin/bash flag overrides the default script execution.
# You get a Linux command line INSIDE the container.
#docker run -it --gpus all --entrypoint /bin/bash -v "$(pwd)/src/neural_extractor_node:/app/data" neural-extractor-node-i



# ---[PyPI PUBLISHING PIPELINE] ---
# uv build
# Allocate token in RAM (Replace YOUR_TOKEN):
# export UV_PUBLISH_TOKEN="pypi-YOUR_TOKEN"
# Transmit artifacts to WAN (PyPI):
# uv publish

#sudo -E env PATH="$PATH" uv
#uv cache dir #~/.cache/uv
#uv cache clean #completely wipe out cache
#uv cache prune #outdated
#uv cache clean numpy #If you suspect a specific package is corrupted or you want to force uv to redownload it, you can target it directly
#sudo -E env PATH="$PATH" uv sync
#sudo -E env PATH="$PATH" uv run python -m src.neural_extractor_node.transcribe


#docker tag neural-extractor-node-i alexberkovich/neural-extractor-node:0.1.3
#docker tag neural-extractor-node-i alexberkovich/neural-extractor-node:latest
#docker push alexberkovich/neural-extractor-node:0.1.3
#docker push alexberkovich/neural-extractor-node:latest


# Delete all containers
# docker rm -f $(docker ps -a -q)

# This command will only show the dangling images
# (images that are not tagged or referenced by any container)
# docker images -f "dangling=true"

# Delete all dangling images
# docker image prune -f

# Delete all unused images
# docker image prune -a -f

# Delete all images
# docker rmi -f $(docker images -q)

# Delete all build cache
# docker builder prune --all
# Verify builder cache deleted
# docker builder du

# https://gallery.ecr.aws/lambda/python/
# docker volume ls
# docker volume ls -q > volumes-to-delete.txt
# Review volumes-to-delete.txt and delete only anonymous or never be used one.
# xargs -r docker volume rm < volumes-to-delete.txt
## docker system prune --all
# docker rm -f neural-extractor-node
# docker rmi -f neural-extractor-node-i


# docker build --no-cache . -t neural-extractor-node-i
# docker build --no-cache --progress=plain . -t neural-extractor-node-i

# docker run --rm -it neural-extractor-node-i bash
# docker exec -it $(docker ps -q -n=1) bash

# sudo docker stats | sudo tee -a docker_stats.log
# sudo watch -n 15 "docker stats --no-stream | sudo tee -a docker_stats.log"
# RAM+SWAP memory
# watch -n 1 free -h
