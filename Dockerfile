FROM postgres:latest

# install Python 3
RUN apt-get update && apt-get install -y python3 python3-pip
RUN apt-get -y install python3.7-dev
RUN apt-get -y install postgresql-server-dev-10 gcc python3-dev musl-dev unzip

# install psycopg2 library with PIP
RUN pip3 install psycopg2 --upgrade

# install awscli
RUN pip3 install awscli --upgrade

RUN aws configure set default.region "eu-west-1"

ADD entrypoint.sh /app/
ADD *.py /app/
ADD startPostgreSQL.sh /app/
ADD database.ini /app/
ADD idle.sh /app/
ADD dvdrental.zip /app/

WORKDIR /app
RUN chmod -R 755 /app &&\
    unzip /app/dvdrental.zip

# add the 'postgres' admin role
USER postgres

RUN chmod 0700 /var/lib/postgresql/data && \
    echo "host all  all    0.0.0.0/0  md5" >> /var/lib/postgresql/data/pg_hba.conf &&\
    echo "listen_addresses='*'" >> /var/lib/postgresql/data/postgresql.conf

# expose Postgres port
EXPOSE 5432

# Add VOLUMEs to allow backup of config, logs and databases
VOLUME  ["/etc/postgresql", "/var/log/postgresql", "/var/lib/postgresql"]

# Set the default command to run when starting the container
# CMD ["/usr/lib/postgresql/12/bin/postgres", "-D", "/var/lib/postgresql/9.3/main", "-c", "config_file=/etc/postgresql/9.3/main/postgresql.conf"]
CMD ["/app/entrypoint.sh"]
