FROM python:3.9.13 AS builder

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1
WORKDIR /app


RUN python -m venv .venv
COPY requirements.txt ./
RUN .venv/bin/pip install --no-cache-dir -r requirements.txt

# Add playwright install in the builder stage as well (safer)
RUN .venv/bin/playwright install --with-deps chromium

# Use the same Python version slim image for the final stage
FROM python:3.9.13-slim

# Install system dependencies needed by Playwright/Chromium
# Need wget and ca-certificates for playwright install command itself
RUN apt-get update && apt-get install -y --no-install-recommends \
    libnss3 \
    libnspr4 \
    libdbus-1-3 \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libcups2 \
    libdrm2 \
    libxkbcommon0 \
    libatspi2.0-0 \
    libxcomposite1 \
    libxdamage1 \
    libxfixes3 \
    libxrandr2 \
    libgbm1 \
    libpango-1.0-0 \
    libcairo2 \
    libasound2 \
    libexpat1 \
    wget \
    ca-certificates \
    # Clean up apt cache
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy the virtual environment with installed packages from the builder
COPY --from=builder /app/.venv .venv/

# Copy the application code
COPY . .

# Ensure the playwright browsers are installed in the final image
# Run this *after* copying .venv which contains the playwright executable
# Using --with-deps might be redundant now but is safe
RUN .venv/bin/playwright install --with-deps chromium

# Set the command to run gunicorn using the shell form to allow $PORT substitution
# Increase worker timeout to 360 seconds for long-running Playwright tasks
ENV PORT=8080
CMD /app/.venv/bin/gunicorn --workers 1 --timeout 360 fotos-aereas-ideib:app --bind :$PORT
