FROM ruby:2.2-slim

ENV PASSENGER_VERSION 5.0.30
ENV WORK_DIR /usr/workdir

ADD sources.list.jessie /etc/apt/sources.list

RUN apt-get update && apt-get install -y --no-install-recommends \
		imagemagick \
		libmysqlclient18 \
		libpq5 \
		libsqlite3-0 \
		\
		bzr \
		git \
		mercurial \
		openssh-client \
		subversion \
	&& rm -rf /var/lib/apt/lists/*

ENV RAILS_ENV production
WORKDIR $WORK_DIR

RUN buildDeps='\
		gcc \
		libmagickcore-dev \
		libmagickwand-dev \
		libmysqlclient-dev \
		libpq-dev \
		libsqlite3-dev \
		make \
		patch \
	' \
	&& set -ex \
	&& apt-get update && apt-get install -y $buildDeps --no-install-recommends \
	&& rm -rf /var/lib/apt/lists/*

# remove all build deps
# && apt-get purge -y --auto-remove $buildDeps


