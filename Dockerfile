FROM centos:centos8

LABEL MAINTAINER="amoydavid"

RUN set -x \
  && dnf install -y https://mirrors.aliyun.com/remi/enterprise/remi-release-8.rpm \
  && curl -o /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-8.repo \
  && yum makecache \
  && dnf module reset php \
  && dnf module install -y php:remi-7.4 \
  && dnf install -y --enablerepo=remi php php-cli php-bcmath php-gd php-gmp \
       php-json php-fpm php-mbstring php-mysqlnd php-pdo php-pecl-mysql php-pecl-memcached php-pecl-redis5 php-xml php-intl php-pecl-xdebug php-zip \
       php-pecl-swoole4 \
       mod_ssl \
  && dnf install -y git \
  && curl -s -o /usr/local/bin/composer https://mirrors.aliyun.com/composer/composer.phar \
  && chmod 755 /usr/local/bin/composer \
  && dnf clean all && mkdir -p /usr/src/app \
  && mkdir -p /home/composer/.composer && \
    ln -s /root/.ssh /home/composer/.ssh 

ENV TIMEZONE=Asia/Shanghai
ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_HOME /home/composer/.composer

RUN mkdir -p /application

COPY etc/php.ini /etc/
# COPY docker/etc/php.d/ /etc/php.d/
# COPY docker/etc/php-zts.d/ /etc/php-zts.d/
COPY etc/php-fpm.conf /etc/
COPY etc/php-fpm.d/ /etc/php-fpm.d/

VOLUME ["/home/composer/.composer"]
VOLUME ["/application"]

WORKDIR /application

RUN composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/

COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod u+x /docker-entrypoint.sh


EXPOSE 9000
EXPOSE 5200

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/bin/env", "php-fpm"]