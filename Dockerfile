# Use the official Alpine Linux image as the base image
FROM alpine:3.12

# Set environment variables
ENV LANG=C.UTF-8

# Install required packages and add the Mopidy APT repository
RUN apk add --no-cache curl gnupg && \
    curl -L https://apt.mopidy.com/mopidy.gpg | apk add --no-cache --key-flags=nosignature - && \
    echo "https://apt.mopidy.com/alpine/v3.12/main" > /etc/apk/repositories/mopidy.repo

# Install Mopidy and its dependencies
RUN apk update && \
    apk add mopidy

# Set the default command to start Mopidy
CMD ["mopidy"]
