FROM alpine:3.7

RUN apk add --no-cache iproute2 ferm

ADD ferm.conf /etc/ferm.conf
ADD entrypoint.sh /usr/local/sbin/entrypoint.sh

ENTRYPOINT [ "/usr/local/sbin/entrypoint.sh" ]
