FROM alpine:3

RUN apk add --update-cache bash curl jq uuidgen

COPY . /root/opentelemetry-shell

WORKDIR /root/opentelemetry-shell/examples

ENTRYPOINT ["bash"]
