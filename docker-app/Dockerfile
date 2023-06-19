FROM perl

# app dependencies
RUN cpanm  \
    HTTP::Server::PSGI \
    Plack \
    && rm -rf /root/.cpanm

# debug dependencies
RUN cpanm Devel::Camelcadedb \
    && rm -rf /root/.cpanm
