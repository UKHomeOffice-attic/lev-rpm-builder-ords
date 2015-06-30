#!/usr/bin/env bash


mkdir -p /root/ords/opt/ords.3.0.0 /root/ords/etc/init.d/
# Prepare
wget "https://www.dropbox.com/s/an70k0q7v9ku0tq/ords.3.0.0.121.10.23.zip&dl=1" -O /root/rpmbuild/ords.3.0.0.121.10.23.zip
unzip /root/rpmbuild/ords.3.0.0.121.10.23.zip -d /root/ords/opt/ords.3.0.0

cp /root/rpmbuild/config/systemv.sh /root/ords/etc/init.d/ords
touch /root/ords/opt/ords.3.0.0/config_updated_at
cp /root/rpmbuild/config/ords_params.properties /root/ords/opt/ords.3.0.0/params/ords_params.properties


cd /root/rpmbuild/

mkdir -p /root/ords/var/logs/ords/ /root/ords/var/run/ords/

fpm -s dir -t rpm -C /root/ords/ \
    -n ords \
    -v 3.0.0.121.10.23 \
    --iteration 1 \
    --vendor apifactory \
    -d "jre" \
    --after-install postinstall.sh \
    --after-remove postremove.sh \
    --config-files etc/init.d/ords \
    --config-files opt/ords.3.0.0/config_updated_at \
    --config-files opt/ords.3.0.0/params/ords_params.properties

cp *.rpm /rpmbuild
