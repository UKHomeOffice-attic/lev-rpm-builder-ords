#!/usr/bin/env bash


mkdir -p /root/ords/opt/ords.3.0.0 /root/ords/etc/init.d/ || exit 1
# Prepare
(wget "https://www.dropbox.com/s/an70k0q7v9ku0tq/ords.3.0.0.121.10.23.zip&dl=1" \
    -O /root/rpmbuild/ords.3.0.0.121.10.23.zip && \
unzip /root/rpmbuild/ords.3.0.0.121.10.23.zip -d /root/ords/opt/ords.3.0.0) || exit 1

cp /root/rpmbuild/config/systemv.sh /root/ords/etc/init.d/ords || exit 1
touch /root/ords/opt/ords.3.0.0/config_updated_at || exit 1
cp /root/rpmbuild/config/ords_params.properties /root/ords/opt/ords.3.0.0/params/ords_params.properties || exit 1


cd /root/rpmbuild/ || exit 1

mkdir -p /root/ords/var/log/ords/ /root/ords/var/run/ords/ || exit 1

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
    --config-files opt/ords.3.0.0/params/ords_params.properties || exit 1

echo ${RPM_OUTPUT_DIR:-/rpmbuild}
ls ${RPM_OUTPUT_DIR:-/rpmbuild}
cp *.rpm "${RPM_OUTPUT_DIR:-/rpmbuild}" || exit 1

