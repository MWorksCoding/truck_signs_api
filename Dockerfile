# ===============================
# 1. Base image
# ===============================
FROM python:3.8-slim
# Prevents .pyc files, logs appear immediately -> keeps container clean and ensures docker logs shows output in real time
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# ===============================
# 2. Set work directory
# ===============================
WORKDIR /app

# ===============================
# 3. Install system dependencies
# ===============================
# mandatory to install for example: gcc, build-essential -> Compile Python packages, libpq-dev -> psycopg2 (PostgreSQL); removing APT cache to reduce image size
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    build-essential \
    libjpeg-dev \
    zlib1g-dev \
    libffi-dev \
    libpq-dev \
    netcat-openbsd \
    && rm -rf /var/lib/apt/lists/*

# ===============================
# 4. Install Python dependencies
# ===============================
COPY requirements.txt .

# ===============================
# 5. Install Python dependencies
# ===============================
# --no-cache-dir keeps image smaller
RUN pip install --upgrade pip && pip install --no-cache-dir -r requirements.txt

# ===============================
# 6. Copy project files
# ===============================
COPY . .

# ===============================
# 7. Copy entrypoint script
# ===============================
# chmod +x = makes it executable
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# ===============================
# 8. Expose port
# ===============================
EXPOSE 8020

# ===============================
# 9. Define container startup command
# ===============================
ENTRYPOINT ["/entrypoint.sh"]
