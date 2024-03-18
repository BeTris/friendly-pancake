# Use a Python base image suitable for Linux
FROM python:3.11.0-slim AS builder

# Set working directory
WORKDIR /app

RUN python -m venv /venv
RUN /venv/bin/pip install poetry




# Copy the Poetry files
COPY pyproject.toml poetry.lock ./

RUN /venv/bin/poetry install

# Install Node.js and npm
RUN apt-get update && \
    apt-get install -y nodejs npm && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy the Flask application code
COPY . .

# Build frontend (assuming you have a frontend directory)
WORKDIR /app/frontend
RUN npm install
RUN npm run build

# Stage 2: Create final image with Linux Ubuntu
FROM ubuntu:20.04

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && \
    apt-get install -y python3 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy built Flask app from the Windows build stage
COPY --from=builder /app /app

# Set environment variables
ENV FLASK_APP=app.py
ENV FLASK_RUN_HOST=0.0.0.0

# Install Gunicorn
RUN pip install gunicorn

# Expose the Gunicorn port
EXPOSE 8000

# Command to run the Flask application with Gunicorn
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "app:app"]
