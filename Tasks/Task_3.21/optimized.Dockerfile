FROM ubuntu:20.04
ENV testenv1=env1

RUN groupadd --gid 2000 user && useradd --uid 2000 --gid 2000 --shell /bin/bash --create-home user

RUN ls -lah /var/lib/apt/lists/
RUN apt-get update -y && apt-get install nginx -y && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN ls -lah /var/lib/apt/lists/

RUN rm -rf /var/lib/apt/lists/*
RUN ls -lah /var/lib/apt/lists/

COPY --chown=user:user testfile .

USER user
CMD ["sleep infinity"]