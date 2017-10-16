FROM ruby:2.4.2

RUN mkdir -p /tools
COPY health-check.sh /tools
HEALTHCHECK --interval=2s CMD /tools/health-check.sh

RUN mkdir -p /app

COPY app/Gemfile app/Gemfile.lock /app/
WORKDIR /app
RUN bundle install --deployment --without development

# Why do this separately? This way, we can take advantage of Docker's caching to only re-run
# 'bundle install' when our list of dependencies have actually changed.
COPY app/lib /app/lib

ENV APP_ENV=production

CMD ["bundle", "exec", "ruby", "/app/lib/international_transfers_service.rb"]

EXPOSE 4567
