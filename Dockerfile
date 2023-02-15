FROM python:3.9

WORKDIR /app

# Install dependencies
RUN apt-get update && apt-get install -y apt-transport-https
RUN pip install psycopg2

# Copy scripts and configuration files
COPY main.py .
COPY config.py .
COPY init.sql /docker-entrypoint-initdb.d/

# Expose Grafana port
EXPOSE 3000

# Start PostgreSQL service
CMD ["postgres", "-D", "/var/lib/postgresql/data", "-c", "config_file=/etc/postgresql/postgresql.conf"]

# Start Python script
CMD python main.py
