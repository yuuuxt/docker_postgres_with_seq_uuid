ARG postgres_version=14

# extension builder
FROM postgres:${postgres_version}-alpine AS extension_builder

RUN cd / && mkdir external_extensions && mkdir /external_extensions/sequential-uuids
COPY lib/sequential-uuids/ /external_extensions/sequential-uuids/
WORKDIR /external_extensions/sequential-uuids/

RUN apk update && apk add build-base icu-dev postgresql-dev
RUN make clean && make install

# main image
FROM postgres:${postgres_version}-alpine

LABEL maintainer="yuxtonline@outlook.com"

COPY --from=extension_builder /usr/local/lib/postgresql/ /usr/local/lib/postgresql/
COPY --from=extension_builder /usr/local/share/postgresql/extension /usr/local/share/postgresql/extension

RUN echo "CREATE EXTENSION IF NOT EXISTS sequential_uuids;" > /docker-entrypoint-initdb.d/create_sequential_uuids.sql