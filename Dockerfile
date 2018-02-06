FROM mmunro/bloatstack:0.1.2-xenial

ENV SERVER_NAME=tellervo

RUN set -e \
  && adduser --disabled-password --gecos '' tellervo \
  && adduser tellervo sudo \
  && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers \
  && echo "ServerName ${SERVER_NAME}" >> /etc/apache2/conf-enabled/servername.conf \
  && wget --directory-prefix=/tmp/ http://www.tellervo.org/tmp/tellervo-server-1.3.3.deb \
  && dpkg --install /tmp/tellervo-server-1.3.3.deb \
  && tellervo-server --auto-configure

# Setup Supervisord to run Apache and Postgres
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Ports to expose
EXPOSE 80

WORKDIR /var/www/tellervo
VOLUME /var/lib/postgresql/data

CMD ["/usr/bin/supervisord"]
