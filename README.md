# TODO


```
docker buildx build --tag tinyproxy:1.0.0 .
```

docker run -it --rm --name tinyproxy\
 --publish 3128:3128\
 --entrypoint sh\
 tinyproxy:1.0.0

-d means run in the foreground

stunnel &
./tinyproxy -d -c ./tinyproxy.conf


Dockerfile informed by https://github.com/tinyproxy/tinyproxy/issues/501#issuecomment-2256073227



CLIENT:

sudo apt install stunnel

cat <<EOF | sudo tee /etc/stunnel/stunnel.conf
client = yes
foreground = yes

[tinyproxy] 
accept = 127.0.0.1:3129
connect = 127.0.0.1:3128
verify = 4 
CAFile = /home/eace/projects/tinyproxy/cert.pem
EOF

sudo stunnel


DOCKERFILE FOR STUNNEL??

RUN apk -no-cache add openssl-dev

ARG STVERSION=5.74
RUN curl -L -o stunnel.tar.gz\
  https://www.stunnel.org/downloads/stunnel-${STVERSION}.tar.gz
RUN mkdir -p stunnel && tar -zxf stunnel.tar.gz -C stunnel --strip-components=1

WORKDIR /stunnel

# build tinyproxy (static linking so we only need the single binary in the run stage)
RUN LDFLAGS=-static ./configure
RUN make
# NO RUN make install

mkdir -p /etc/stunnel


