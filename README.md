Docker container for Odoo 8

To run the container:

docker run -d --log-driver=journald --privileged \
  -v /etc/odoo:/etc/odoo \
  -v /var/lib/odoo:/var/lib/odoo \
  -v /sys/fs/cgroup:/sys/fs/cgroup:ro \
  -p 8069:8069 -p 8072:8072 \
  lorissantamaria/odoo8

First time you run the container you must edit
/etc/odoo/openerp-server.conf and point the odoo instance to a working
PostgreSQL install, and change the master password. After that, restart
the container and point your browser at http://your.docker.host:8069

Server logs are visible with journalctl from the host
