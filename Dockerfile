FROM registry.access.redhat.com/ubi8/ubi-minimal:8.4
# FROM redhat/ubi8/ubi-minimal:8.4

MAINTAINER "TychoDev <cloud.ops@tychodev.com>"

ARG gitlab_pip_token
ENV GITLAB_PIP_TOKEN=$gitlab_pip_token
ENV GITLAB_PIP_USER=__token__

ENV PYTHON_VERSION=3.9 \
    PATH=$HOME/.local/bin/:$PATH \
    PYTHONUNBUFFERED=1 \
    PYTHONIOENCODING=UTF-8 \
    PIP_NO_CACHE_DIR=off

# MicroDNF is recommended over YUM for Building Container Images
# https://www.redhat.com/en/blog/introducing-red-hat-enterprise-linux-atomic-base-image

RUN microdnf install -y python39 \
    && microdnf clean all

RUN pip3 install poetry \
    && poetry config virtualenvs.create false \
    && poetry config http-basic.gitlab ${GITLAB_PIP_USER} ${GITLAB_PIP_TOKEN} \

#USER 1001

RUN python3 --version && pip3 --version
