#!/bin/bash

set -x
id myuser
if [ "$?" != "0" ]; then
	if [ -z $RUN_USER_ID ] && [ -z $RUN_GROUP_ID ]; then
		groupadd -r mygroup && useradd -r -g mygroup myuser
	elif [ ! -z $RUN_USER_ID ] && [ ! -z $RUN_GROUP_ID ]; then
		groupadd -r myuser -g $RUN_GROUP_ID
		useradd -r -g $RUN_GROUP_ID -u $RUN_USER_ID myuser
	else 
		echo "wrong RUN_USER_ID[$RUN_USER_ID] and RUN_GROUP_ID[$RUN_GROUP_ID]"
		exit 1
	fi
fi

set -e

case "$1" in
	rails|rake|passenger)

		# ensure the right database adapter is active in the Gemfile.lock
		bundle install --without development test
		
		if [ ! -s config/secrets.yml ]; then
			if [ "$REDMINE_SECRET_KEY_BASE" ]; then
				cat > 'config/secrets.yml' <<-YML
					$RAILS_ENV:
					  secret_key_base: "$REDMINE_SECRET_KEY_BASE"
				YML
			elif [ ! -f /usr/workdir/config/initializers/secret_token.rb ]; then
				rake generate_secret_token
			fi
		fi
		if [ "$1" != 'rake' -a -z "$REDMINE_NO_DB_MIGRATE" ]; then
			gosu myuser rake db:migrate
		fi
		
		chown -R $RUN_USER_ID:$RUN_GROUP_ID files log public/plugin_assets
		
		if [ "$1" = 'passenger' ]; then
			# Don't fear the reaper.
			set -- tini -- "$@"
		fi
		
		set -- gosu $RUN_USER_ID "$@"
		;;
esac

exec "$@"
