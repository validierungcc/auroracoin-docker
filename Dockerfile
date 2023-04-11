FROM ubuntu:22.04 AS builder

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        git \
        make \
        g++ \
        autoconf \
        automake \
        libtool \
        pkg-config \
        libdb++-dev \
        libboost-all-dev \
        libssl-dev \
        libevent-dev \
        ca-certificates \
        bsdmainutils
RUN addgroup --gid 1000 aurora && \
    adduser --disabled-password --gecos "" --home /aurora --ingroup aurora --uid 1000 aurora

USER aurora
WORKDIR /aurora
RUN mkdir .auroracoin
VOLUME /aurora/.auroracoin

RUN git clone https://github.com/aurarad/Auroracoin.git auroracoin
WORKDIR /aurora/auroracoin
RUN git checkout tags/2022.06.1.0

RUN ./autogen.sh
RUN ./configure --without-gui
RUN make

FROM ubuntu:22.04

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        libdb++-dev \
        libboost-all-dev \
        libssl-dev \
        libevent-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY --from=builder /aurora/auroracoin/src/auroracoind /usr/local/bin/auroracoind
COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh

RUN addgroup --gid 1000 aurora && \
    adduser --disabled-password --gecos "" --home /aurora --ingroup aurora --uid 1000 aurora

USER aurora
WORKDIR /aurora
RUN mkdir .auroracoin
VOLUME /aurora/.auroracoin

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
EXPOSE 12340/tcp
EXPOSE 12341/tcp
