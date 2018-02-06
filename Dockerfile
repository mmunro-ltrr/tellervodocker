FROM mmunro/bloatstack:0.1.1-xenial

ENV SERVER_NAME=tellervo

RUN set -e \
  && adduser --disabled-password --gecos '' tellervo \
  && adduser tellervo sudo \
  && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers \
  && wget --directory-prefix=/tmp/ http://www.tellervo.org/tmp/tellervo-server-1.3.3.deb \
  && dpkg --install /tmp/tellervo-server-1.3.3.deb \
  && sudo -u tellervo tellervo-server --auto-configure \
  && echo "ServerName ${SERVER_NAME}" >> /etc/apache2/conf-enabled/servername.conf

# Setup Supervisord to run Apache and Postgres
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Ports to expose
EXPOSE 80

WORKDIR /var/www/tellervo
VOLUME /var/lib/postgresql/data

CMD ["/usr/bin/supervisord"]
