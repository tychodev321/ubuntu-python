FROM ubuntu:22.10

LABEL maintainer=""

ENV PYTHON_VERSION=3.10.10 \
    PATH=$HOME/.local/bin/:$PATH \
    PYTHONUNBUFFERED=1 \
    PYTHONIOENCODING=UTF-8 \
    PIP_NO_CACHE_DIR=off \
    POETRY_VERSION=1.2.2

# Install Base Tools
RUN apt update -y && apt upgrade -y \
    && apt install -y unzip \
    && apt install -y gzip \
    && apt install -y tar \
    && apt install -y wget \
    && apt install -y curl \
    && apt clean -y \
    && rm -rf /var/lib/apt/lists/*

# Install Python
RUN apt update -y && apt upgrade -y \
    && apt install -y python3-pip \
    && apt install -y python3-venv \
    && apt install -y python3-setuptools \
    && apt install -y python-is-python3 \
    && apt clean -y \
    && rm -rf /var/lib/apt/lists/*

# Configure Python
ENV PATH=/root/.local/bin:$PATH

# Install pipx and poetry
RUN python -m pip install --user pipx \
    && python -m pipx ensurepath --force \
    && pipx install poetry==${POETRY_VERSION}

RUN echo "python version: $(python --version)" \
    && echo "pip version - $(python -m pip --version)" \
    && echo "poetry about: $(poetry about)" \
    && echo "git version: $(git --version)"

# USER 1001

CMD ["echo", "This is a 'Purpose Built Image', It is not meant to be ran directly"]
