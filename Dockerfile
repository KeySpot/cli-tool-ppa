FROM ubuntu
WORKDIR /app
COPY . .
RUN apt-get update -y
RUN apt-get -y install git wget dpkg-dev apt-utils gnupg
CMD ["./update.sh"]