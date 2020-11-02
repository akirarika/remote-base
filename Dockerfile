FROM debian:buster

ARG system_timezone="Etc/UTC"
ARG system_sources_domain="http://mirrors.cloud.tencent.com"
ARG system_apt_install=""

ARG ssh_authorized_keys=""

ARG zsh_install_script="https://cdn.jsdelivr.net/gh/robbyrussell/oh-my-zsh@master/tools/install.sh"

RUN echo "Initing system.." \
    && export DEBIAN_FRONTEND=noninteractive \
    && echo "${system_timezone}" > /etc/timezone \
    && echo "deb ${system_sources_domain}/debian/ buster main non-free contrib" > /etc/apt/sources.list \
    && echo "deb-src ${system_sources_domain}/debian/ buster main non-free contrib" >> /etc/apt/sources.list \
    && echo "deb ${system_sources_domain}/debian-security/ buster/updates main" >> /etc/apt/sources.list \
    && echo "deb-src ${system_sources_domain}/debian-security/ buster/updates main" >> /etc/apt/sources.list \
    && echo "deb ${system_sources_domain}/debian/ buster-updates main non-free contrib" >> /etc/apt/sources.list \
    && echo "deb-src ${system_sources_domain}/debian/ buster-updates main non-free contrib" >> /etc/apt/sources.list \
    && echo "deb ${system_sources_domain}/debian/ buster-backports main non-free contrib" >> /etc/apt/sources.list \
    && echo "deb-src ${system_sources_domain}/debian/ buster-backports main non-free contrib" >> /etc/apt/sources.list \
    && apt update \
    && apt clean

RUN apt install -y curl wget tzdata lsof git net-tools tzdata lsb-release apt-transport-https ca-certificates openssl tar zip unzip \
    ${system_apt_install} \
    && apt clean

RUN echo "Installng ssh.." \
    && apt install -y openssh-server \
    && mkdir -p /var/run/sshd \
    && mkdir -p /root/.ssh \
    && echo "${ssh_authorized_keys}" > /authorized_keys \
    && apt clean

RUN echo "Installng zsh.." \
    && apt install -y zsh \
    && wget "${zsh_install_script}" -O - | zsh || true \
    && apt clean

RUN echo "#!/bin/bash" > /rc.sh \
    && echo "mv -f /authorized_keys /root/.ssh && chmod -R 700 /root/.ssh && /usr/sbin/sshd -D" > /rc.sh \
    && chmod 700 /rc.sh \
    && mkdir /workspace \
    && chmod 700 /workspace

WORKDIR /workspace

EXPOSE 22

ENTRYPOINT [ "/bin/bash", "/rc.sh" ]