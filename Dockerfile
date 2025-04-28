FROM ubuntu:20.04

ENV ACCEPT_EULA=Y
ENV DB_NAME=eboard_local
ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

COPY init-db.sh /init-db.sh
COPY offline-debs/ /all-packages/

RUN chmod +x /init-db.sh

RUN dpkg -i \
    /all-packages/readline-common_8.0-4_all.deb \
    /all-packages/libsigsegv2_2.12-2_amd64.deb \
    /all-packages/libmpfr6_4.0.2-1_amd64.deb \
    /all-packages/libreadline8_8.0-4_amd64.deb && \
    apt-get install -f -y

RUN dpkg -i /all-packages/gawk_1%3a5.0.1+dfsg-1ubuntu0.1_amd64.deb && \
    apt-get install -f -y

RUN dpkg -i \
    /all-packages/libssl1.1_1.1.1f-1ubuntu2.24_amd64.deb \
    /all-packages/libexpat1_2.2.9-1ubuntu0.8_amd64.deb \
    /all-packages/libpython3.8-minimal_3.8.10-0ubuntu1~20.04.18_amd64.deb \
    /all-packages/python3.8-minimal_3.8.10-0ubuntu1~20.04.18_amd64.deb \
    && apt-get install -f -y

RUN dpkg -i /all-packages/python3-minimal_3.8.2-0ubuntu2_amd64.deb && apt-get install -f -y

RUN dpkg -i \
    /all-packages/libmpdec2_2.4.2-3_amd64.deb \
    /all-packages/libsqlite3-0_3.31.1-4ubuntu0.6_amd64.deb && apt-get install -f -y

RUN dpkg -i \
    /all-packages/mime-support_3.64ubuntu1_all.deb \
    /all-packages/libpython3.8-stdlib_3.8.10-0ubuntu1~20.04.18_amd64.deb \
    /all-packages/libpython3-stdlib_3.8.2-0ubuntu2_amd64.deb && apt-get install -f -y

RUN dpkg -i \
    /all-packages/python3.8_3.8.10-0ubuntu1~20.04.18_amd64.deb && apt-get install -f -y


RUN dpkg -i /all-packages/python3_3.8.2-0ubuntu2_amd64.deb && apt-get install -f -y

RUN apt-get update && \
    dpkg -i /all-packages/*.deb || true && \
    apt-get install -f -y

RUN echo 'export PATH="$PATH:/opt/mssql-tools18/bin"' >> /etc/profile
RUN ln -s /opt/mssql-tools18/bin/* /usr/local/bin/

RUN rm -rf /all-packages /var/lib/apt/lists/*

EXPOSE 1433

CMD ["/init-db.sh"]
