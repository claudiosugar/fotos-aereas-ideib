FROM ubuntu:22.04

# Set environment variables
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    DEBIAN_FRONTEND=noninteractive

# Install Python and required dependencies
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-venv \
    wget \
    git \
    && rm -rf /var/lib/apt/lists/*

# Create and set working directory
WORKDIR /app

# Install Playwright dependencies
RUN apt-get update && apt-get install -y \
    libnss3 \
    libnspr4 \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libcups2 \
    libdrm2 \
    libxkbcommon0 \
    libxcomposite1 \
    libxdamage1 \
    libxfixes3 \
    libxrandr2 \
    libgbm1 \
    libasound2 \
    libpango-1.0-0 \
    libcairo2 \
    fonts-liberation \
    libappindicator3-1 \
    libudev1 \
    xvfb \
    xauth \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements and install dependencies
COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Create screenshots directory
RUN mkdir -p screenshots

# Install and pre-download Playwright browsers
# Use Xvfb to create a virtual display for Playwright installation
RUN PLAYWRIGHT_BROWSERS_PATH=/app/ms-playwright \
    python3 install_playwright.py

# Expose port
EXPOSE 8080

# Set the entrypoint using Xvfb for headless browser support
ENV PORT=8080 \
    PLAYWRIGHT_BROWSERS_PATH=/app/ms-playwright

# Start app with Xvfb to provide virtual display
# Add memory limit for Node.js used by Playwright
ENV NODE_OPTIONS="--max-old-space-size=3072"
CMD xvfb-run --auto-servernum --server-args="-screen 0 1280x960x24" \
    gunicorn --bind 0.0.0.0:$PORT --timeout 600 --workers 1 --threads 2 fotos-aereas-ideib:app
