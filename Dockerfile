FROM golang:1.8-alpine
RUN pwd
RUN echo 'here is current locatin $pwd'

WORKDIR /go/src/hello-app
ADD . /go/src/hello-app
ADD src src
RUN go install hello-app

FROM alpine:latest
COPY --from=0 /go/bin/hello-app .
ENV PORT 8080
CMD ["./hello-app"]
