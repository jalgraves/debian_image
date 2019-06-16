ARG image=debian:stretch-slim
FROM ${image}

ARG python_version=3.7.3
ARG filebeat_version=7.0.0

RUN apt-get update && apt-get full-upgrade -y
RUN apt-get install -y apt-utils

RUN apt-get install -y curl \
    build-essential \
    zlib1g-dev \
    libncurses5-dev \
    libgdbm-dev \
    libnss3-dev \
    libssl-dev \
    libreadline-dev \
    libffi-dev \
    libpq-dev \
    wget

RUN curl -O https://www.python.org/ftp/python/${python_version}/Python-${python_version}.tar.xz
RUN tar -xf Python-${python_version}.tar.xz

WORKDIR /Python-${python_version}/

RUN ./configure --enable-optimizations
RUN make -j 4
RUN make install

WORKDIR /

RUN rm Python-${python_version}.tar.xz
RUN rm -rf Python-${python_version}/
RUN ln -s /usr/local/bin/python3 /usr/local/bin/python

RUN curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-${filebeat_version}-amd64.deb
RUN dpkg -i filebeat-${filebeat_version}-amd64.deb
RUN rm filebeat-${filebeat_version}-amd64.deb

COPY ./filebeat.yml /etc/filebeat/
COPY ./entrypoint.sh /
COPY ./requirements.txt /
RUN pip3 install --upgrade pip
RUN pip3 install -r requirements.txt

ENTRYPOINT [ "/bin/sh", "entrypoint.sh" ]
