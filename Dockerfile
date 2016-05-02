FROM centos:centos7
MAINTAINER Loris Santamaria "loris@lgs.com.ve"

ENV container docker
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;

ADD odoo-nightly.repo /etc/yum.repos.d/odoo-nightly.repo
RUN mkdir /usr/share/doc/odoo; yum -y install epel-release; yum -y install odoo wkhtmltopdf python-gevent xorg-x11-server-Xvfb

ADD wkhtmltopdf.sh /usr/local/bin/wkhtmltopdf
ADD odoo-firstboot.service /etc/systemd/system/odoo-firstboot.service
ADD openerp-server.conf /usr/share/doc/odoo/openerp-server.conf-default
RUN systemctl enable odoo; systemctl enable odoo-firstboot.service; chmod +x /usr/local/bin/wkhtmltopdf

EXPOSE 8069 8072

VOLUME ["/sys/fs/cgroup"]
VOLUME  ["/var/lib/odoo"]
VOLUME  ["/etc/odoo"]

CMD ["/usr/sbin/init"]
