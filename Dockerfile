FROM ubuntu:16.04
RUN apt-get update
USER $USER_NAME
WORKDIR /Work
