FROM centos:centos7
MAINTAINER Loris Santamaria "loris@lgs.com.ve"

ENV container=docker

RUN systemctl mask systemd-remount-fs.service dev-hugepages.mount sys-fs-fuse-connections.mount systemd-logind.service getty.target console-getty.service
RUN cp /usr/lib/systemd/system/dbus.service /etc/systemd/system/; sed -i 's/OOMScoreAdjust=-900//' /etc/systemd/system/dbus.service

ADD odoo-nightly.repo /etc/yum.repos.d/odoo-nightly.repo
RUN mkdir /usr/share/doc/odoo; yum -y install epel-release; yum -y install odoo wkhtmltopdf python-gevent xorg-x11-server-Xvfb

ADD wkhtmltopdf.sh /usr/local/bin/wkhtmltopdf
ADD odoo-firstboot.service /etc/systemd/system/odoo-firstboot.service
ADD openerp-server.conf /usr/share/doc/odoo/openerp-server.conf-default
RUN systemctl enable odoo; systemctl enable odoo-firstboot.service; chmod +x /usr/local/bin/wkhtmltopdf

EXPOSE 8069 8072

VOLUME ["/sys/fs/cgroup", "/run", "/tmp"]
VOLUME  ["/var/lib/odoo"]
VOLUME  ["/etc/odoo"]

CMD ["/usr/sbin/init"]
