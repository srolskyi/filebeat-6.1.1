FROM centos:7
LABEL maintainer "Serg Rolskyi <sergii.rolskyi@linux-tricks.net>"

ENV FILEBEAT_VERSION 6.1.1

ENV ELASTIC_CONTAINER true
ENV FILEBEAT_HOME /usr/share/filebeat
ENV PATH=${FILEBEAT_HOME}:$PATH

RUN yum update -y && yum install -y fontconfig freetype && yum clean all

RUN curl -Ls https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-${FILEBEAT_VERSION}-linux-x86_64.tar.gz | tar zxf - -C /tmp && \
    mv /tmp/filebeat-${FILEBEAT_VERSION}-linux-x86_64 ${FILEBEAT_HOME}

ADD docker-entrypoint /usr/local/bin

RUN chmod +x /usr/local/bin/docker-entrypoint

RUN groupadd --gid 1000 filebeat && \
    useradd -M --uid 1000 --gid 1000 \
      --home ${FILEBEAT_HOME} filebeat 

WORKDIR ${FILEBEAT_HOME}

RUN mkdir data logs && \
    chown -R root:filebeat . && \
    find ${FILEBEAT_HOME} -type d -exec chmod 0750 {} \; && \
    find ${FILEBEAT_HOME} -type f -exec chmod 0640 {} \; && \
    chmod 0750 ${FILEBEAT_HOME}/filebeat && \
    chmod 0770 modules.d && \
    chmod 0770 data logs

USER filebeat

ENTRYPOINT [ "/usr/local/bin/docker-entrypoint" ]


CMD [ "-e", "-c", "${FILEBEAT_HOME}/filebeat.yml" ]
