FROM debian:buster AS builder
RUN apt-get update && apt-get -y install build-essential libboost-all-dev libssl-dev && rm -rf /var/lib/apt/lists/*
COPY . /var/src
WORKDIR /var/src
RUN make

FROM debian:buster
EXPOSE 53/udp
VOLUME /data

ENV SEED_DOMAIN=example.com
ENV SEED_HOST=seed1
ENV SEED_NS=vps
ENV SEED_PORT=53

RUN apt-get update && apt-get -y install libssl1.1 && rm -rf /var/lib/apt/lists/*

WORKDIR /data

COPY --from=builder /var/src/dnsseed /usr/local/bin/

CMD dnsseed -h ${SEED_HOST}.${SEED_DOMAIN} -n ${SEED_NS}.${SEED_DOMAIN} -m admin.${SEED_DOMAIN} -p ${SEED_PORT}
