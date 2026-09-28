FROM ubuntu:latest

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        bash \
        iputils-ping \
        procps \
        util-linux \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY app/ ./app/

RUN chmod +x ./app/app.sh

ENTRYPOINT ["./app/app.sh"]