#!/usr/bin/env bash

adduser ords

chown ords /opt/ords.3.0.0
chown ords /var/logs/ords
chown ords /var/run/ords

echo /var/run/ords/

chmod a+x /etc/init.d/ords

ln -s ../init.d/ords /etc/rc.d/rc3.d/S99-ords
ln -s ../init.d/ords /etc/rc.d/rc3.d/K99-ords

/etc/init.d/ords start
