FROM python:3.11-slim

WORKDIR /app

RUN pip install flask

COPY app/app.py .

EXPOSE 5000

CMD ["python", "app.py"]