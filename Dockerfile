FROM php:8-fpm-alpine
ARG GOODUSER
ARG UID
ARG MAIL
ARG NOM

RUN echo "$GOODUSER($UID):$GROUP($GID)"

# installation bash
RUN apk --no-cache update && apk --no-cache add bash git npm shadow

# installation de composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
&& php composer-setup.php --install-dir=/usr/local/bin \
&& php -r "unlink('composer-setup.php');"

# installation de symfony
RUN wget https://get.symfony.com/cli/installer -O - | bash \
&& mv /root/.symfony5/bin/symfony /usr/local/bin/symfony

# Gestion user
RUN echo "UID_MAX $UID" > /etc/login.defs
RUN /usr/sbin/useradd --create-home -s /bin/sh -u "$UID" $GOODUSER
USER $GOODUSER

# config git
RUN git config --global user.email $MAIL
RUN git config --global user.name $NOM


WORKDIR /var/www/html
