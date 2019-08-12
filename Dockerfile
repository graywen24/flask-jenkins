FROM golang:1.8-alpine
RUN pwd
RUN echo 'here is current locatin $pwd'
ADD . /go/src/hello-app
WORKDIR /go/src/hello-app
RUN go install hello-app

FROM alpine:latest
COPY --from=0 /go/bin/hello-app .
ENV PORT 8080
CMD ["./hello-app"]
