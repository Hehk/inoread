FROM flyio/postgres-flex:15.3

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        curl \
        postgresql-server-dev-all

ARG PGVECTOR_VERSION=0.4.4

RUN curl -L -o pgvector.tar.gz "https://github.com/ankane/pgvector/archive/refs/tags/v${PGVECTOR_VERSION}.tar.gz" && \
    tar -xzf pgvector.tar.gz && \
    cd "pgvector-${PGVECTOR_VERSION}" && \
    make && \
    make install

RUN apt-get remove -y build-essential curl postgresql-server-dev-all && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /pgvector.tar.gz /pgvector-${PGVECTOR_VERSION}
