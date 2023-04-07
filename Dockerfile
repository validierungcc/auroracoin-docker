FROM alpine:3.17
RUN apk add --no-cache git make g++ bash

RUN addgroup --gid 1000 aurora
RUN adduser \
    --disabled-password \
    --gecos "" \
    --home /auroracoin \
    --ingroup auroracoin \
    --uid 1000 \
    aurora

USER auroracoin
RUN mkdir /aurora/.auroracoin
VOLUME /aurora/.auroracoin

RUN git clone https://github.com/auroracoinproject/auroracoin.git /aurora/auroracoin
WORKDIR /aurora/auroracoin
RUN git checkout tags/2022.06.1.0

WORKDIR /aurora/auroracoin/src
RUN make -f makefile.unix
COPY ./entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
EXPOSE 12340/tcp
EXPOSE 12341/tcp
