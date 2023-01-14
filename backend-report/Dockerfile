FROM python:latest
COPY . /app
WORKDIR /app

RUN mkdir --parents ~/.mongodb && wget "https://storage.yandexcloud.net/cloud-certs/CA.pem" --output-document ~/.mongodb/root.crt && chmod 0644 ~/.mongodb/root.crt
RUN apt update && apt install --yes python3 python3-pip && pip3 install pyMongo
RUN pip install -r requirements.txt
ENTRYPOINT ["python"]
CMD ["app.py"]
EXPOSE 8080