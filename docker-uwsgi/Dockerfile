FROM ubuntu

# perl deps
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       bzip2 \
       ca-certificates \
       # cpio \
       curl \
       dpkg-dev \
       # file \
       gcc \
       # g++ \
       # libbz2-dev \
       # libdb-dev \
       libc6-dev \
       # libgdbm-dev \
       # liblzma-dev \
       make \
       netbase \
       patch \
       # procps \
       zlib1g-dev \
       xz-utils \
       libssl-dev \
    && rm -rf /var/cache/apt/* /var/lib/apt/lists/*

# uwsgi psgi
RUN apt update  \
    && apt install -y \
    perl \
    cpanminus \
    uwsgi \
    uwsgi-plugin-psgi \
    && rm -rf /var/cache/apt/* /var/lib/apt/lists/*

# app dependencies
RUN apt update \
    && apt install -y \
    libplack-perl \
    && rm -rf /var/lib/apt/lists/*

# debug dependencies
RUN cpanm Devel::Camelcadedb \
    Plack::Middleware::Camelcadedb \
    && rm -rf /root/.cpanm
