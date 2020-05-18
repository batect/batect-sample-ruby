FROM postgres:12.3

RUN mkdir -p /tools
COPY health-check.sh /tools/

HEALTHCHECK --interval=0.2s --retries=20 CMD /tools/health-check.sh

COPY create-structure.sql /docker-entrypoint-initdb.d/
