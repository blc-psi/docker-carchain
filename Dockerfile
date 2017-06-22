FROM dfherr/ruby:2.4.1
MAINTAINER Dennis-Florian Herr <herrdeflo@gmail.com>

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -; \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

RUN sudo apt-get update
RUN sudo apt-get --yes install          \
      libpq-dev                         \
      yarn

WORKDIR /carchain

ADD ["/src/Gemfile", "/src/Gemfile.lock", "/carchain/"]

RUN sudo chown -R ubuntu: /carchain

RUN bundle install --path ./.bundle --binstubs .bundle/bin

ADD /src /carchain

RUN sudo chown -R ubuntu: /carchain

ADD bin/start_carchain /usr/local/bin/start_carchain
RUN sudo chmod 0755 /usr/local/bin/start_carchain

CMD ["start_carchain"]
