FROM node:20-slim

# Puppeteer 필수 패키지
RUN apt-get update && apt-get install -y \
    wget \
    ca-certificates \
    fonts-noto-cjk \
    --no-install-recommends \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY package.json ./
RUN npm install

COPY . .

ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=false
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/google-chrome

CMD ["node", "index.js"]
