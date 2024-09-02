FROM ruby:3.3.1

WORKDIR /shypple

COPY . .

RUN bundle install

ENTRYPOINT ["ruby", "shypple.rb"]