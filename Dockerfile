
FROM debian:buster-slim
MAINTAINER João Eduardo Soares e Silva

WORKDIR /root

RUN echo 'APT::Get::Assume-Yes "true";' > /etc/apt/apt.conf.d/90extra \
  && echo 'DPkg::Options "--force-confnew";' >> /etc/apt/apt.conf.d/90extra

ENV DEBIAN_FRONTEND=noninteractive

COPY FirebirdSS-2.1.7.18553-0.amd64.rpm /root

RUN apt-get update \
  && apt-get install locales ca-certificates alien libncurses5 libstdc++5 \
  && alien FirebirdSS-2.1.7.18553-0.amd64.rpm \
  && dpkg -i firebirdss_2.1.7.18553-1_amd64.deb \
  && apt-get remove alien \
  && apt-get clean \
  && mkdir -v /firebird \
  && ln -sf /usr/share/zoneinfo/Etc/UTC /etc/localtime \
  && ln -sf /dev/stdout /opt/firebird/firebird.log \
  && locale-gen C.UTF-8 || true

ENV LANG=C.UTF-8

COPY firebird.conf /opt/firebird/firebird.conf

EXPOSE 3050/tcp

VOLUME ["/firebird"]
VOLUME ["/firebird-dev"]

CMD ["/opt/firebird/bin/fbguard"]
