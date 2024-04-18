FROM postgres:10

ADD sources.list.jessie /etc/apt/sources.list

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
      gcc \
      make \
      libc-dev \
      postgresql-server-dev-$PG_MAJOR \
      wget \
      unzip \
      ca-certificates \
      openssl \
	&& rm -rf /var/lib/apt/lists/* \
  && wget -q -O - "http://www.xunsearch.com/scws/down/scws-1.2.3.tar.bz2" | tar xjf - \
  && wget -O zhparser.zip "https://github.com/amutu/zhparser/archive/master.zip" \
  && unzip zhparser.zip \
  && cd scws-1.2.3 \
  && ./configure \
  && make install \
  && cd /zhparser-master \
  && SCWS_HOME=/usr/local make && make install \
  # pg_trgm is recommend but not required.
  && echo "CREATE EXTENSION pg_trgm; \n\
CREATE EXTENSION zhparser; \n\
CREATE TEXT SEARCH CONFIGURATION chinese_zh (PARSER = zhparser); \n\
ALTER TEXT SEARCH CONFIGURATION chinese_zh ADD MAPPING FOR n,v,a,i,e,l,t WITH simple;" \
> /docker-entrypoint-initdb.d/init-zhparser.sql \
  && apt-get purge -y gcc make libc-dev postgresql-server-dev-$PG_MAJOR \
  && apt-get autoremove -y \
  && rm -rf \
    /zhparser-master \
    /zhparser.zip \
    /scws-1.2.3
