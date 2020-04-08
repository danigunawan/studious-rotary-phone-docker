FROM ruby:2.6.6-alpine
# Default ENV variables
ENV MAIL_SMTP_PORT 587
ENV MAIL_SMTP_AUTH_TYPE plain
ENV BUNDLE_SILENCE_ROOT_WARNING=1

RUN apk add --no-cache --update build-base \
			linux-headers \
			git \
			postgresql-dev \
# Su-exec for easy step down from root
			'su-exec>=0.2' \
# tzdata for https://github.com/docker-library/redis/issues/138
			tzdata \
			redis \
			&& rm -rf /var/cache/apk/* && gem install bundler 

# Create non-privileged user and group, to use with su-exec
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
RUN mkdir -p /home/appuser/app
RUN chmod 774 -R /home/appuser/
RUN chgrp appgroup -R /home/appuser
RUN chown appuser -R /home/appuser
WORKDIR  /home/appuser

# Start Redis in daemon mode (non-root)
RUN su-exec appuser:appgroup redis-server  --daemonize yes 
RUN su-exec appuser:appgroup git clone \
	https://github.com/pmop/studious-rotary-phone app && \ 
	cd app && \
	bundle install

WORKDIR  /home/appuser/app

EXPOSE 3000
