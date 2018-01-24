FROM centos:7
LABEL maintainer "Serg Rolskyi <sergii.rolskyi@linux-tricks.net>"

ENV FILEBEAT_VERSION 6.1.1

ENV ELASTIC_CONTAINER true
ENV PATH=/usr/share/filebeat/bin:$PATH

RUN yum update -y && yum install -y fontconfig freetype && yum clean all

WORKDIR /usr/share/filebeat
RUN curl -Ls https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-${FILEBEAT_VERSION}-linux-x86_64.tar.gz | tar --strip-components=1 -zxf - && \
    ln -s /usr/share/filebeat /opt/filebeat

ADD docker-entrypoint.sh /usr/local/bin/

RUN groupadd --gid 1000 filebeat && \
    useradd --uid 1000 --gid 1000 \
      --home-dir /usr/share/filebeat --no-create-home \
      filebeat

USER filebeat

CMD /usr/local/bin/docker-entrypoint.sh
