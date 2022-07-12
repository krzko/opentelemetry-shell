FROM alpine:3

RUN apk add --update-cache bash curl jq

COPY . /root/opentelemetry-shell

RUN chmod +x /root/opentelemetry-shell/*.sh

WORKDIR /root/opentelemetry-shell/examples

ENTRYPOINT ["bash"]
