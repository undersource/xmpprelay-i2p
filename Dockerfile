FROM golang:alpine as builder
COPY go.mod go.sum main.go /build/
RUN cd /build   \
  && go get     \
  && go build .
FROM alpine
ENV HOST="0.0.0.0" PORT="9626" PROXY=i2pd PROXY_PORT="4447"
COPY --from=builder /build/xmpprelay /usr/bin/
ENTRYPOINT xmpprelay -l $HOST:$PORT -r $PROXY:$PROXY_PORT
