FROM python:3.11-slim

WORKDIR /speechkit-service

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app/ ./app

EXPOSE 8081

CMD ["fastapi", "run", "app/server.py", "--port", "8081"]