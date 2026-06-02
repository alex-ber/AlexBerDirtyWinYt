#[DECOHERENCE_BOUNDARY]: Ubuntu Base (Size Limit: IGNORED)
# Absolute Phase Lock. Pointer tags (e.g., :24.04) are PROHIBITED.
# docker pull ubuntu:24.04
# docker inspect --format='{{index .RepoDigests 0}}' ubuntu:24.04
# Retrieve the current pointer for UV:
# docker pull ghcr.io/astral-sh/uv:latest
# docker inspect --format='{{index .RepoDigests 0}}' ghcr.io/astral-sh/uv:latest
# docker run --rm ubuntu:24.04 bash -c "apt-get update > /dev/null && apt-cache policy ca-certificates"

FROM ubuntu@sha256:c4a8d5503dfb2a3eb8ab5f807da5bc69a85730fb49b5cfca2330194ebcc41c7b

#[HARDWARE_CONFIG]: Deterministic execution and compilation flags
ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1 \
    LANG=C.UTF-8 \
    PYTHONDONTWRITEBYTECODE=1 \
    UV_COMPILE_BYTECODE=1 \
    UV_LINK_MODE=copy \
    UV_PROJECT_ENVIRONMENT="/opt/venv" \
    PATH="/opt/venv/bin:$PATH"

WORKDIR /app

#[HARDWARE_BRIDGE]: Injecting UV Compiler (AOT Dependency Graph Resolver)
COPY --from=ghcr.io/astral-sh/uv@sha256:3a59a3cdd5f7c217faa36e32dbc7fddbb0412889c2a0a5229f6d790e5a019dd7 /uv /uvx /bin/



#[RUNTIME_ENVIRONMENT]: Deterministic APT Projection & Root Python Allocation
# Hard package pinning for maximum reproducibility.
# ca-certificates pinned to exact version + hold + preferences to prevent ANY upgrade.
RUN set -ex && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates=20240203 \
        nano=7.2-2ubuntu0.1 \
        ffmpeg=7:6.1.1-3ubuntu5 \
    && rm -rf /var/lib/apt/lists/* \
    && apt-mark hold ca-certificates nano ffmpeg \
    # Extra strict pinning: prevent newer versions even if they appear in repositories
    && echo 'Package: ca-certificates' > /etc/apt/preferences.d/ca-certificates-pin \
    && echo 'Pin: version 20240203' >> /etc/apt/preferences.d/ca-certificates-pin \
    && echo 'Pin-Priority: 1001' >> /etc/apt/preferences.d/ca-certificates-pin \
    && update-ca-certificates --fresh \
    && rm -rf /var/lib/apt/lists/* \
    # STRICT LOCK: TOML requires >=3.11, <=3.12 (Crucial for torch 2.12.0 + cu130 compatibility)
    && uv python install 3.12.3





#[DEPENDENCY_INJECTION]: Top-Down Directed Acyclic Graph Mount
COPY pyproject.toml uv.lock ./

#[POINTER_ALLOCATION]: Synthetic Mock-Node Cache Strategy
# Bypasses hatchling early parse exception, isolating dependency layer from source layer jitter.
RUN set -ex && \
    mkdir -p src/neural_extractor_node && \
    echo '__version__ = "0.1.0"' > src/neural_extractor_node/__init__.py && \
    uv sync --no-install-project

#[AST_COPY]: Mount Root Logic
COPY src/ src/

#[PROJECT_INJECTION]: Finalize Symbol Table Linkage
RUN set -ex && \
    uv sync

#[ENTRYPOINT]: Hardware Transition (Main Thread Execution)
CMD ["uv", "run", "python", "-m", "src.neural_extractor_node.transcribe"]


# ---[STATELESS BIRUR DAEMON] ---
# To regenerate uv.lock WITHOUT installing uv on the Host OS, run this ephemeral hypervisor:
# docker run --rm -v "$(pwd):/app" -w /app ghcr.io/astral-sh/uv:python3.12-bookworm-slim uv lock

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

#uv cache dir #~/.cache/uv
#uv cache clean #completely wipe out cache
#uv cache prune #outdated
#uv cache clean numpy #If you suspect a specific package is corrupted or you want to force uv to redownload it, you can target it directly



#docker tag neural-extractor-node-i alexberkovich/neural-extractor-node:0.1.0
#docker tag neural-extractor-node-i alexberkovich/neural-extractor-node:latest
#docker push alexberkovich/neural-extractor-node:0.1.0
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
# docker system prune --all
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
