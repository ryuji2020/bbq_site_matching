FROM ruby:2.5.3

RUN apt-get update -qq \
  && apt-get install -y build-essential libpq-dev nodejs \
  && sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
  && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
  && apt update \
  && apt-get -y install google-chrome-stable \
  && apt-get -y install mysql-server mysql-client \
  && apt-get -y install vim \
  && apt-get install less

ENV APP_ROOT /bbq_site_matching
ENV LANG C.UTF-8
RUN mkdir $APP_ROOT
WORKDIR $APP_ROOT

ADD ./Gemfile $APP_ROOT/Gemfile
ADD ./Gemfile.lock $APP_ROOT/Gemfile.lock

RUN bundle install
ADD . $APP_ROOT
