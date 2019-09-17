FROM registry.access.redhat.com/rhel7
ARG RHSM_USERNAME
ARG RHSM_PASSWORD
ARG RHSM_POOL_ID

ENV container=docker

RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
    rm -f /lib/systemd/system/multi-user.target.wants/*;\
    rm -f /etc/systemd/system/*.wants/*;\
    rm -f /lib/systemd/system/local-fs.target.wants/*; \
    rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
    rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
    rm -f /lib/systemd/system/basic.target.wants/*;\
    rm -f /lib/systemd/system/anaconda.target.wants/*;

RUN subscription-manager register --username=$RHSM_USERNAME --password=$RHSM_PASSWORD \
    && subscription-manager attach --pool=$RHSM_POOL_ID \
    && subscription-manager repos --enable rhel-7-server-ansible-2.8-rpms \
    && yum -y update \
    && yum -y install \
        ansible \
        audit \
        cronie \
        firewalld \
        grub2 \
        sudo \
        which \
        less \
        openssh-server \
        python-devel \
        python-passlib \
        sudo \
        vim \
    && rm -rf /var/cache/yum \
    && subscription-manager unregister

# Disable requiretty.
RUN sed -i -e 's/^\(Defaults\s*requiretty\)/#--- \1/'  /etc/sudoers

RUN echo '# BLANK FSTAB' > /etc/fstab

# Remove unnecessary getty and udev targets that can result in high CPU usage when using
# multiple containers with Molecule (https://github.com/ansible/molecule/issues/1104)
RUN rm -f /lib/systemd/system/systemd*udev* \
  && rm -f /lib/systemd/system/getty.target
# Install Ansible inventory file.
RUN echo -e "localhost ansible_connection=local ansible_python_interpreter=/usr/bin/python" > /etc/ansible/hosts

# Create `ansible` user with sudo permissions
ENV ANSIBLE_USER=ansible SUDO_GROUP=wheel
RUN set -xe \
  && groupadd -r ${ANSIBLE_USER} \
  && useradd -m -g ${ANSIBLE_USER} ${ANSIBLE_USER} \
  && usermod -aG ${SUDO_GROUP} ${ANSIBLE_USER} \
  && echo "ansible:password" | chpasswd \
  && sed -i "/^%${SUDO_GROUP}/s/ALL\$/NOPASSWD:ALL/g" /etc/sudoers

VOLUME ["/sys/fs/cgroup"]
#CMD ["/usr/sbin/init"]
CMD ["/usr/lib/systemd/systemd"]
