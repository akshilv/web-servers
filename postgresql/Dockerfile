FROM postgres:11-alpine
ENV POSTGRES_DB web-server-db
ENV POSTGRES_USER web-server-user
ENV POSTGRES_PASSWORD web-server-password
COPY create-db.sql /docker-entrypoint-initdb.d/