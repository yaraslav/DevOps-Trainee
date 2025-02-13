ARG NG_VERSION=latest

FROM nginx:${NG_VERSION}

ARG NG_VERSION
ENV NG_VERSION=${NG_VERSION}

ARG ARG_FILE=default.txt

RUN touch /opt/${ARG_FILE} && \
    echo "NG_VERSION=${NG_VERSION}" > /opt/${ARG_FILE}


