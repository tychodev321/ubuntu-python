FROM registry.access.redhat.com/ubi9/ubi-minimal:9.0.0
# FROM redhat/ubi9/ubi-minimal:9.0.0

LABEL maintainer=""

ENV PYTHON_VERSION=3 \
    PATH=$HOME/.local/bin/:$PATH \
    PYTHONUNBUFFERED=1 \
    PYTHONIOENCODING=UTF-8 \
    PIP_NO_CACHE_DIR=off \
    POETRY_VERSION=1.2.2

# MicroDNF is recommended over YUM for Building Container Images
# https://www.redhat.com/en/blog/introducing-red-hat-enterprise-linux-atomic-base-image

# Install Tools
RUN microdnf update -y \
    && microdnf install -y git \
    && microdnf clean all \
    && rm -rf /var/cache/* /var/log/dnf* /var/log/yum.*

# Install the latest version of Python
RUN microdnf update -y \
    && microdnf install -y python${PYTHON_VERSION} \
    && microdnf install -y python${PYTHON_VERSION}-devel \
    && microdnf install -y python${PYTHON_VERSION}-setuptools \
    && microdnf install -y python${PYTHON_VERSION}-pip \
    && microdnf clean all \
    && rm -rf /var/cache/* /var/log/dnf* /var/log/yum.*

# Configure Python
ENV PATH=/root/.local/bin:$PATH

# Install pipx and poetry
RUN python -m pip install --user pipx \
    && python -m pipx ensurepath --force \
    && pipx install poetry==${POETRY_VERSION}

RUN echo "python version: $(python --version)" \
    && echo "pip version - $(python -m pip --version)" \
    && echo "git version: $(git --version)" \
    && microdnf repolist

USER 1001

CMD ["echo", "This is a 'Purpose Built Image', It is not meant to be ran directly"]
