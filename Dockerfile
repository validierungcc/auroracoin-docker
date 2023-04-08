FROM alpine:3.17.3 AS builder
RUN apk add --no-cache git make g++ bash autoconf automake libtool pkgconfig db-dev boost-dev openssl-dev libevent-dev

RUN addgroup --gid 1000 aurora
RUN adduser \
    --disabled-password \
    --gecos "" \
    --home /aurora \
    --ingroup aurora \
    --uid 1000 \
    aurora

USER aurora
RUN mkdir /aurora/.auroracoin
VOLUME /aurora/.auroracoin

RUN git clone https://github.com/aurarad/Auroracoin.git /aurora/auroracoin
WORKDIR /aurora/auroracoin
RUN git checkout tags/2022.06.1.0

WORKDIR /aurora/auroracoin/

FROM builder AS compiler

RUN ./autogen.sh
RUN ./configure --without-gui
RUN make
COPY ./entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
EXPOSE 12340/tcp
EXPOSE 12341/tcp
