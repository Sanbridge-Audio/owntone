# Use the official Python image as the base image
FROM python:3.9-alpine

# Set environment variables
ENV LANG=C.UTF-8

# Install required packages and upgrade pip
RUN apk add --no-cache --update alsa-lib-dev && \
    apk add --no-cache --virtual .build-deps build-base && \
    pip install --no-cache-dir --upgrade pip

# Install Mopidy and its dependencies
RUN pip install --no-cache-dir mopidy

# Set the default command to start Mopidy
CMD ["mopidy"]
