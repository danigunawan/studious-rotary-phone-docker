FROM ruby:2.6.6-alpine
# Default ENV variables
ENV MAIL_SMTP_PORT 587
ENV PORT 3000
ENV POSTGRES_PORT 5432
ENV RAILS_ENV development
ENV MAIL_SMTP_AUTH_TYPE plain
ENV BUNDLE_SILENCE_ROOT_WARNING=1
ENV APP_SRC https://github.com/pmop/studious-rotary-phone/archive/docker.zip

RUN apk add --no-cache --update build-base \
			linux-headers \
			libarchive-tools \
			wget \
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

RUN su-exec appuser:appgroup wget ${APP_SRC} -O app.zip && \ 
	su-exec appuser:appgroup bsdtar --strip-components=1 -C app \
	 -xvf app.zip && \ 
	su-exec appuser:appgroup rm app.zip 

WORKDIR /home/appuser/app
RUN bundle install

EXPOSE $PORT
EXPOSE $POSTGRES_PORT
ENTRYPOINT ["su-exec", "appuser:appgroup"]
CMD ["sh", "-c", "rails s -p $PORT -b '0.0.0.0'"]
