FROM ubuntu:20.04 AS builder

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y git make g++ bash autoconf automake libtool pkg-config libdb++-dev libboost-all-dev libssl-dev libevent-dev bsdmainutils

RUN addgroup --gid 1000 aurora && \
    adduser --disabled-password --gecos "" --home /aurora --ingroup aurora --uid 1000 aurora

USER aurora
WORKDIR /aurora
RUN mkdir .auroracoin
VOLUME /aurora/.auroracoin

RUN git clone https://github.com/aurarad/Auroracoin.git auroracoin
WORKDIR /aurora/auroracoin
RUN git checkout tags/2022.06.1.0

FROM builder AS compiler

RUN ./autogen.sh
RUN ./configure --without-gui
RUN make
COPY ./entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
EXPOSE 12340/tcp
EXPOSE 12341/tcp
