#! /bin/bash

#Если свалится одна из команд, рухнет и весь скрипт
set -xe

#Удаляем старый архив
sudo rm -f /home/${DEV_USER}/sausage-store-frontend.tar.gz

#Удаляем файлы проекта, в том числе и скрытые файлы
sudo rm -rf /var/www-data/dist/frontend/{*,.*}||true

#Скачиваем артефакт
sudo cp -rf sausage-store-frontend.service /etc/systemd/system/sausage-store-frontend.service
curl -u ${NEXUS_REPO_USER}:${NEXUS_REPO_PASS} -o sausage-store-frontend.tar.gz ${NEXUS_REPO_URL_FRONTEND}sausage-store/${VERSION}/sausage-store-frontend-${VERSION}.tar.gz

#Переносим файлы проекта в нужную папку
tar xvf sausage-store-frontend.tar.gz
sudo cp -rf ./frontend/* /var/www-data/dist/frontend

#Обновляем конфиг systemd с помощью рестарта
sudo systemctl daemon-reload

#Перезапускаем сервис сосисочной
sudo systemctl restart sausage-store-frontend.service