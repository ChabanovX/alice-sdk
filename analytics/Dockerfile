FROM python:3.11-slim

WORKDIR /analytics-service

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app/ ./app
COPY api-keys.txt ./api-keys.txt

EXPOSE 8000

CMD ["fastapi", "run", "app/main.py", "--port", "8000"]
