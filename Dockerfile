FROM ubuntu
WORKDIR /app
COPY . .
RUN apt-get update && apt-get install -y python3
RUN python3 -m pip install requests
RUN python3 bin/build.py