docker network create my-network
docker run --name my-postgres -e POSTGRES_PASSWORD=mysecretpassword -p 5432:5432 --network my-network -v postgres-data:/var/lib/postgresql/data -d postgres
docker build -t my-python .
docker run --name my-python --network my-network -e DB_HOST=my-postgres -e DB_USER=myuser -e DB_PASSWORD=mysecretpassword -e DB_NAME=mydb -d my-python
docker run --name my-grafana --network my-network -p 4000:3000 -v ./das/:/etc/grafana/provisioning/dashboards/ -v ./dashboards/:/var/lib/grafana/dashboards -d grafana/grafana:latest