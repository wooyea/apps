FROM mariadb:10.1

COPY docker-entrypoint.sh /

RUN apt-get update && apt-get install -y \
        mariadb-connect-engine-10.1 \
        && rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["mysqld"]
