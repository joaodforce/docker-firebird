
FROM debian:buster-slim
MAINTAINER João Eduardo Soares e Silva

RUN echo 'APT::Get::Assume-Yes "true";' > /etc/apt/apt.conf.d/90extra \
  && echo 'DPkg::Options "--force-confnew";' >> /etc/apt/apt.conf.d/90extra

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
  && apt-get install locales ca-certificates alien libncurses5 libstdc++5

RUN ln -sf /usr/share/zoneinfo/Etc/UTC /etc/localtime

RUN locale-gen C.UTF-8 || true
ENV LANG=C.UTF-8

COPY FirebirdSS-2.1.7.18553-0.amd64.rpm /root

WORKDIR /root

RUN alien FirebirdSS-2.1.7.18553-0.amd64.rpm \
  && dpkg -i firebirdss_2.1.7.18553-1_amd64.deb

COPY firebird.conf /opt/firebird/firebird.conf

EXPOSE 3050/tcp

CMD ["/opt/firebird/bin/fbguard"]
