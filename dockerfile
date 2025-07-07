FROM python:3.10-slim

# Install system dependencies needed to build C extensions (like greenlet, cffi, psycopg2)
RUN apt-get update && apt-get install -y \
    gcc \
    libc6-dev \
    build-essential \
    libpq-dev \
    libffi-dev \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy requirements.txt before copying everything (leverages Docker cache)
COPY requirements.txt .

# Install Python dependencies
RUN pip install --upgrade pip && \
    pip install -r requirements.txt

# Copy the rest of the application code
COPY . .

# 👇 Ensure .env is copied (if it's not ignored anymore)
COPY .env .env

# Set environment variable (helps uvicorn find your app)
ENV PYTHONPATH=/app

# Run the FastAPI app
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]