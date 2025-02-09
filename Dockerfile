FROM cgr.dev/chainguard/wolfi-base AS build

RUN apk --no-cache add curl make build-base openssl-dev

WORKDIR /stunnel

ARG STVERSION=5.74
RUN curl -Lo stunnel.tar.gz\
  https://www.stunnel.org/downloads/stunnel-${STVERSION}.tar.gz
RUN tar -zxf stunnel.tar.gz --strip-components=1


RUN LDFLAGS=-static ./configure
RUN make

#FROM cgr.dev/chainguard/wolfi-base AS build-tinyproxy
#
## install tools needed to get and build tinyproxy
#RUN apk --no-cache add curl make build-base

WORKDIR /tinyproxy

# get tinyproxy source
ARG TPVERSION=1.11.2
RUN curl -Lo tinyproxy.tar.gz\
  https://github.com/tinyproxy/tinyproxy/releases/download/${TPVERSION}/tinyproxy-${TPVERSION}.tar.gz
RUN tar -zxf tinyproxy.tar.gz --strip-components=1

# build tinyproxy (static linking so we only need the single binary in the run stage)
RUN LDFLAGS=-static ./configure
RUN make

FROM cgr.dev/chainguard/wolfi-base AS run

WORKDIR /tinyproxy
COPY --from=build /stunnel/src/stunnel /tinyproxy/src/tinyproxy .
# OLD COPY *.pem tinyproxy.conf startup.sh .
# NEW:
COPY *.pem stunnel.conf tinyproxy.conf startup.sh .

# THIS WORKED BEFORE BUILDING AS A LAYER
## # install stunnel and copy configuration file
## RUN apk --no-cache add stunnel && rm /etc/stunnel/*
## COPY stunnel.conf /etc/stunnel/

ENTRYPOINT [ "./startup.sh" ]
