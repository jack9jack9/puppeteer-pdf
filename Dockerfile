FROM node:20-slim

# 필수 패키지 설치
RUN apt-get update && apt-get install -y \
    wget \
    ca-certificates \
    fonts-liberation \
    libappindicator3-1 \
    libasound2 \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libcups2 \
    libdbus-1-3 \
    libgdk-pixbuf2.0-0 \
    libnspr4 \
    libnss3 \
    libx11-xcb1 \
    libxcomposite1 \
    libxdamage1 \
    libxrandr2 \
    xdg-utils \
    --no-install-recommends && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# 작업 디렉토리
WORKDIR /app

# 패키지 복사
COPY package.json ./
COPY package-lock.json ./

# puppeteer 설치 (Chrome 다운로드 옵션 비활성화)
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
RUN npm install

# 소스 복사
COPY . .

# 엔트리포인트
CMD ["node", "index.js"]
