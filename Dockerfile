FROM python:3.11-slim-bookworm   # ← поменяли на актуальную и поддерживаемую базу

WORKDIR /app

# dependencies for psycopg2 + dnsutils
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        dnsutils \
        libpq-dev \
        python3-dev \
        build-essential \          # ← ЭТО главное для компиляции psycopg2
        pkg-config && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Обновляем pip (твоя версия 22.0.4 уже сильно устарела)
RUN python -m pip install --no-cache-dir --upgrade pip setuptools wheel

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 8000


CMD ["gunicorn", "--bind", "0.0.0.0:8000", "--workers", "6", "pygoat.wsgi"]
