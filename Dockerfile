# Use the official Node.js 20 image
FROM node:20

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -qy tini libc++1

# Set working directory
WORKDIR /app

# Expose port 3000
EXPOSE 3000