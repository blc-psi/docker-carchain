FROM dfherr/ruby:2.4.1
MAINTAINER Dennis-Florian Herr <herrdeflo@gmail.com>

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -; \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list; \
    sudo apt-get update; \
    sudo apt-get --yes install software-properties-common; \
    sudo add-apt-repository ppa:ethereum/ethereum; \
    sudo apt-get update && sudo apt-get --yes install \
      libpq-dev \
      ruby-gettext \
      yarn \
      solc; \
    sudo rm -rf /var/lib/apt/lists/*; \
    sudo rm -rf /var/cache/apt/*; \
    sudo apt-get purge -y --auto-remove software-properties-common;


ADD bin/start_carchain /usr/local/bin/start_carchain
RUN sudo chmod 0755 /usr/local/bin/start_carchain

WORKDIR /carchain

ADD ["/src/Gemfile", "/src/Gemfile.lock", "/carchain/"]

RUN sudo chown -R ubuntu: /carchain

RUN bundle install --path ./.bundle --binstubs .bundle/bin && sudo chown -R ubuntu: /carchain/.bundle

ADD /src /carchain

# we chowned bundle above and only chown the src here to avoid unnecessary image bloating
RUN find /carchain -name .bundle -prune -o -print | xargs sudo chown ubuntu:

CMD ["start_carchain"]
