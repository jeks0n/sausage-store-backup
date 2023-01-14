#! /bin/bash

#Если свалится одна из команд, рухнет и весь скрипт
set -xe

#Перезаливаем дескриптор сервиса на ВМ для деплоя
sudo cp -rf sausage-store-backend.service /etc/systemd/system/sausage-store-backend.service
sudo rm -f /home/jarservice/sausage-store.jar||true
sudo cp -rf ~/sausage-store.conf /etc/sausage-store/sausage-store.conf
sudo rm -f ~/sausage-store.conf||true

#Скачиваем артефакт в нужную папку
curl -u ${NEXUS_REPO_USER}:${NEXUS_REPO_PASS} -o sausage-store.jar ${NEXUS_REPO_URL_BACKEND}com/yandex/practicum/devops/sausage-store/${VERSION}/sausage-store-${VERSION}.jar
sudo cp ./sausage-store.jar /home/jarservice/sausage-store.jar||true #"jar||true" говорит, если команда обвалится — продолжай

#Меняем пользователя и группу на файлы
sudo chown -R jarservice:jarservice /home/jarservice/

#Устанавливаем сертификаты для подключения к БД
#postgres
mkdir -p ~/.postgresql && \
wget "https://storage.yandexcloud.net/cloud-certs/CA.pem" -O ~/.postgresql/root.crt && \
chmod 0600 ~/.postgresql/root.crt
#mongo
sudo mkdir -p /usr/local/share/ca-certificates/Yandex && \
sudo wget "https://crls.yandex.net/allCAs.pem" -O /usr/local/share/ca-certificates/Yandex/YandexInternalRootCA.crt

#Обновляем конфиг systemd с помощью рестарта
sudo systemctl daemon-reload

#Перезапускаем сервис сосисочной
sudo systemctl restart sausage-store-backend.service