# docker build -t gopost .
# docker run -it gopost

# Builder side
FROM golang:1.23.6-alpine3.21 AS builder

## add git
RUN apk update && apk add --no-cache git

## move all file to post05 dir
RUN mkdir /post05
ADD . /post05/

## cd post05
WORKDIR /post05

## build
RUN go mod tidy
RUN go build -o server main.go

# Host
FROM alpine:latest
## migrate from builder side
RUN mkdir /post05
COPY --from=builder /post05/server /post05/server
WORKDIR /post05

## execution
CMD ["/post05/server"]