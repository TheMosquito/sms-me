FROM ubuntu:18.04

# Install python3 and net-tools
RUN apt-get update && apt-get install -y \
  python3 \
  python3-dev \
  python3-pip \
  net-tools \
  curl jq vim \
  && rm -rf /var/lib/apt/lists/*

# Install the netifaces and requests libraries
RUN pip3 install --upgrade pip
RUN pip3 install netifaces requests

# Copy the python source file
COPY ./sms.py /

# Start the apache2 server and monitor the error log forever
WORKDIR /
CMD python3 /sms.py

