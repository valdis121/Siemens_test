FROM python:3.9

WORKDIR /app

# Install dependencies
RUN apt-get update && apt-get install -y apt-transport-https
RUN wget -q -O - https://packages.grafana.com/gpg.key | apt-key add -
RUN echo "deb https://packages.grafana.com/oss/deb stable main" | tee -a /etc/apt/sources.list.d/grafana.list
RUN apt-get update && apt-get install -y grafana
RUN pip install psycopg2

# Copy scripts and configuration files
COPY main.py .
COPY grafana.ini /etc/grafana/
COPY datasources.yaml /etc/grafana/provisioning/datasources/
COPY dashboards.yaml /etc/grafana/provisioning/dashboards/
COPY dashboards/dashboard.json /etc/grafana/provisioning/dashboards/
COPY config.py .
COPY init.sql /docker-entrypoint-initdb.d/

# Configure PostgreSQL
ENV POSTGRES_USER myuser
ENV POSTGRES_PASSWORD mypassword
ENV POSTGRES_DB mydb

# Expose Grafana port
EXPOSE 3000

# Start PostgreSQL service
CMD ["postgres", "-D", "/var/lib/postgresql/data", "-c", "config_file=/etc/postgresql/postgresql.conf"]

# Start Python script
CMD python main.py && tail -f /dev/null
