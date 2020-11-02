# remote-base

适用于远程场景的 docker 基础镜像

## Files

```bash
/authorized_keys
```

存放经过授权的主机的公钥，该文件的内容会在容器启动时、ssh 服务启动前复制到 `/root/.ssh/authorized_keys`

```bash
/rc.sh
```

容器启动时会执行的脚本，启动其他程序时请 `RUN your_application >> /rc.sh` 而不要 `CMD your_application`，否则会导致 ssh 等服务不被启动。

## Args

`system_timezone` 系统时区，默认为 Etc/UTC

`system_sources_domain` 系统镜像源，默认为腾讯云

`system_apt_install` 需要 apt 安装的额外内容

`ssh_authorized_keys` 内容会被写入到 /authorized_keys
