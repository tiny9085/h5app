FROM alpine:3.12

RUN mkdir /app

WORKDIR /app

COPY dist /app/
