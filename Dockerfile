# seq uuid: https://github.com/tvondra/sequential-uuids
# ref: https://github.com/docker-library/postgres/issues/340
FROM postgres:13 AS extension_builder

# Already download extension code
RUN cd / && mkdir external_extensions && mkdir /external_extensions/sequential-uuids
COPY lib/sequential-uuids/ /external_extensions/sequential-uuids/
WORKDIR /external_extensions/sequential-uuids/

# additional: change sources.list, but postgres source is still slow. don't need if proxy is used.
# RUN echo "deb http://mirrors.tuna.tsinghua.edu.cn/debian/ buster main contrib non-free" > /etc/apt/sources.list
# RUN echo "deb http://mirrors.tuna.tsinghua.edu.cn/debian/ buster-updates main contrib non-free" >> /etc/apt/sources.list
# RUN echo "deb http://mirrors.tuna.tsinghua.edu.cn/debian/ buster-backports main contrib non-free" >> /etc/apt/sources.list
# RUN echo "deb http://mirrors.tuna.tsinghua.edu.cn/debian-security buster/updates main contrib non-free" >> /etc/apt/sources.list


RUN apt-get update && apt install build-essential libicu-dev postgresql-server-dev-all -y --no-install-recommends
RUN make clean && make install

FROM postgres:13
#if use alpine: the paths are different!

# run find / -name 'sequential_uuids*' to find newly compiled files and copy to next stage
COPY --from=extension_builder /usr/lib/postgresql/12/lib /usr/lib/postgresql/13/lib
COPY --from=extension_builder /usr/share/postgresql/12/extension /usr/share/postgresql/13/extension

# after in sql:
# CREATE EXTENSION sequential_uuids;
