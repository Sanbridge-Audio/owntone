# Use the official Debian image as the base image
FROM debian

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Install required packages and add the Mopidy APT repository
RUN apt-get update && \
    apt-get install -y curl gnupg2 apt-transport-https && \
    curl -L https://apt.mopidy.com/mopidy.gpg | apt-key add - && \
    echo "deb https://apt.mopidy.com/buster stable main contrib non-free" > /etc/apt/sources.list.d/mopidy.list

# Install Mopidy and its dependencies
RUN apt update && apt install mopidy

# Set the default command to start Mopidy
CMD ["mopidy"]
