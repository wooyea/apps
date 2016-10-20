FROM apps/ruby:2.2-base

ENV RAILS_ENV production
ENV PASSENGER_VERSION 5.0.30
ENV WORK_DIR /usr/workdir
ENV BUNDLE_PATH ${WORK_DIR}/vendor/bundle

ADD sources.list.jessie /etc/apt/sources.list


WORKDIR $WORK_DIR

RUN set -ex \
	&& gem install -s "https://gems.ruby-china.org" passenger --version "$PASSENGER_VERSION"

COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 3000
CMD ["passenger", "start"]
CMD ["rails", "server", "-b", "0.0.0.0"]


