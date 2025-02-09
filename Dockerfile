FROM cgr.dev/chainguard/wolfi-base AS build

RUN apk --no-cache add curl make build-base openssl-dev

# get and build stunnel

WORKDIR /stunnel

ARG STVERSION=5.74
RUN curl -Lo stunnel.tar.gz\
  https://www.stunnel.org/downloads/stunnel-${STVERSION}.tar.gz
RUN tar -zxf stunnel.tar.gz --strip-components=1
RUN LDFLAGS=-static ./configure
RUN make

# get and build tinyproxy

WORKDIR /tinyproxy

ARG TPVERSION=1.11.2
RUN curl -Lo tinyproxy.tar.gz\
  https://github.com/tinyproxy/tinyproxy/releases/download/${TPVERSION}/tinyproxy-${TPVERSION}.tar.gz
RUN tar -zxf tinyproxy.tar.gz --strip-components=1
RUN LDFLAGS=-static ./configure
RUN make

# build final image

FROM cgr.dev/chainguard/wolfi-base AS run

WORKDIR /tinyproxy
COPY --from=build /stunnel/src/stunnel /tinyproxy/src/tinyproxy .
COPY *.pem *.conf startup.sh .

ENTRYPOINT [ "./startup.sh" ]
