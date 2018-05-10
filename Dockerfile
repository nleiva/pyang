FROM alpine:3.7

WORKDIR /usr/src/pyang

# Install Python3 and PIP
RUN apk add --no-cache \
  python3 python3-dev && \
  python3 -m ensurepip && \
  rm -r /usr/lib/python*/ensurepip && \
  pip3 install --upgrade pip setuptools && \
  if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi && \
  if [[ ! -e /usr/bin/python ]]; then ln -sf /usr/bin/python3 /usr/bin/python; fi && \
  rm -r /root/.cache

# Dependencies as an environment variable
ENV DEPS linux-headers \
  gcc \
  git \
  musl-dev \
  bash \ 
  libxslt-dev \
  libxml2-dev \
  libxslt \
  pkgconf

# Install system dependencies (latest list of available packages)
RUN apk --update add --no-cache $DEPS

# Copy the code to the Container 
COPY . .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Install pyang
RUN python setup.py install