#
# MariaDB Dockerfile
#
# https://github.com/dockerfile/mariadb
#

# Pull base image.
FROM resin/rpi-raspbian:wheezy

# Install MariaDB.
RUN \
  sudo apt-get update && \
  sudo apt-get -y install wget && \
  sudo wget -O /etc/apt/sources.list.d/repository.pi3g.com.list http://repository.pi3g.com/sources.list && \
  wget -O - http://repository.pi3g.com/pubkey | sudo apt-key add - && \
  sudo apt-get update && \                                                         
  sudo apt-get upgrade  && \
  apt-get -y install mariadb-server
RUN \
  sed -i 's/^\(bind-address\s.*\)/# \1/' /etc/mysql/my.cnf && \
  echo "mysqld_safe &" > /tmp/config && \
  echo "mysqladmin --silent --wait=30 ping || exit 1" >> /tmp/config && \
  echo "mysql -e 'GRANT ALL PRIVILEGES ON *.* TO \"root\"@\"%\" WITH GRANT OPTION;'" >> /tmp/config && \
  bash /tmp/config && \
  rm -f /tmp/config

# Define mountable directories.
VOLUME ["/etc/mysql", "/var/lib/mysql"]

# Define working directory.
WORKDIR /data

# Define default command.
CMD ["mysqld_safe"]

# Expose ports.
EXPOSE 3306
