ARG postgres_version=15rc2

# extension builder
FROM postgres:${postgres_version} AS extension_builder
ARG postgres_version=15rc2

RUN cd / && mkdir external_extensions && mkdir /external_extensions/sequential-uuids
COPY lib/sequential-uuids/ /external_extensions/sequential-uuids/
WORKDIR /external_extensions/sequential-uuids/

RUN apt-get update && apt install build-essential libicu-dev postgresql-server-dev-${postgres_version} -y --no-install-recommends
RUN make clean && make install

# main image
FROM postgres:${postgres_version}
ARG pg_version_in_path=15rc2

LABEL maintainer="yuxtonline@outlook.com"

COPY --from=extension_builder /usr/lib/postgresql/${pg_version_in_path}/lib /usr/lib/postgresql/${pg_version_in_path}/lib
COPY --from=extension_builder /usr/share/postgresql/${pg_version_in_path}/extension /usr/share/postgresql/${pg_version_in_path}/extension

RUN echo "CREATE EXTENSION IF NOT EXISTS sequential_uuids;" > /docker-entrypoint-initdb.d/create_sequential_uuids.sql
