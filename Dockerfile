# Базовый образ: Python 3.11 + Debian 12 (bookworm) — актуально в 2026 году
FROM python:3.11-slim-bookworm

WORKDIR /app

# Устанавливаем системные зависимости (включая компилятор для psycopg2)
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        dnsutils \
        libpq-dev \
        python3-dev \
        build-essential \
        pkg-config && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Остальной Dockerfile без изменений
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

RUN python -m pip install --no-cache-dir --upgrade pip setuptools wheel

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 8000

CMD ["gunicorn", "--bind", "0.0.0.0:8000", "--workers", "6", "pygoat.wsgi"]
