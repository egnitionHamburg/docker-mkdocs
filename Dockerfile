FROM alpine:3.18.3

ENV MKDOCS_VERSION=1.5.2 \
    DOCS_DIRECTORY='/mkdocs' \
    LIVE_RELOAD_SUPPORT='false' \
    ADD_MODULES='false' \
    FAST_MODE='false' \
    PYTHONUNBUFFERED=1 \
    GIT_REPO='false' \
    GIT_BRANCH='master' \
    AUTO_UPDATE='false' \
    UPDATE_INTERVAL=15

ADD container-files/ /

RUN \
    apk add --update \
    ca-certificates \
    bash \
    git \
    openssh \
    python3 \
    python3-dev \
    py3-pip \
    build-base && \
    pip install --upgrade pip && \
    pip install mkdocs==${MKDOCS_VERSION} && \
    cd /bootstrap && pip install -e /bootstrap && \
    rm -rf /tmp/* /var/tmp/* /var/cache/apk/* /var/cache/distfiles/* && \
    chmod 600 /root/.ssh/config

RUN sed -i '5 i sys.path.append(r"/bootstrap")' /usr/bin/bootstrap

RUN pip install mkdocs-awesome-pages-plugin

CMD ["/usr/bin/python3", "/bootstrap/main.py", "start"]
