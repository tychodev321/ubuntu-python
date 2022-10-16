FROM registry.access.redhat.com/ubi9/ubi-minimal:9.0.0
# FROM redhat/ubi9/ubi-minimal:9.0.0

LABEL maintainer=""

ENV PYTHON_VERSION=3 \
    PATH=$HOME/.local/bin/:$PATH \
    PYTHONUNBUFFERED=1 \
    PYTHONIOENCODING=UTF-8 \
    PIP_NO_CACHE_DIR=off \
    POETRY_VERSION=1.2.0

# MicroDNF is recommended over YUM for Building Container Images
# https://www.redhat.com/en/blog/introducing-red-hat-enterprise-linux-atomic-base-image

RUN microdnf update -y \
    && microdnf install -y python${PYTHON_VERSION} \
    && microdnf install -y python${PYTHON_VERSION}-pip \
    && microdnf clean all \
    && rm -rf /var/cache/* /var/log/dnf* /var/log/yum.*

# Make sure to upgrade pip3
RUN pip3 install --upgrade pip \ 
    && python3 -m pip install --user pipx \
    && python3 -m pipx ensurepath --force

ENV PATH=/root/.local/bin:$PATH

RUN pipx install poetry==${POETRY_VERSION}

RUN python3 --version && pip3 --version

# USER 1001

CMD ["echo", "This is a 'Purpose Built Image', It is not meant to be ran directly"]
