FROM ruby:2.7.0

RUN mkdir -p /tools
COPY health-check.sh /tools
HEALTHCHECK --interval=2s CMD /tools/health-check.sh

RUN mkdir -p /app

COPY app/Gemfile app/Gemfile.lock /app/
WORKDIR /app
RUN bundle install --deployment --without development

ENV APP_ENV=production
CMD ["/app/bin/international-transfers-service"]
EXPOSE 4567

# Why do this separately? This way, we can take advantage of Docker's caching to only re-run
# 'bundle install' when our list of dependencies have actually changed.
COPY app/config.ru /app
COPY app/bin /app/bin
COPY app/lib /app/lib
