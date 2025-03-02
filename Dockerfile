FROM ruby:3.2

WORKDIR /app

COPY . .

RUN bundle install

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]

