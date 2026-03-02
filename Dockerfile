FROM python:3.11-slim-bookworm

WORKDIR /app

# dependencies for psycopg2 + dnsutils
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        dnsutils \
        libpq-dev \
        python3-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

RUN python -m pip install --no-cache-dir --upgrade pip

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt || true
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 8000

RUN python manage.py migrate   # если нужно при сборке (обычно лучше в entrypoint при запуске)

CMD ["gunicorn", "--bind", "0.0.0.0:8000", "--workers", "6", "pygoat.wsgi"]
