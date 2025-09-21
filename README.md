# CMD2RDF-Docker
Docker Compose setup for CMD2RDF. 

This Docker Compose setup creates 3 containers:

- graphdb: a GraphDB instance.
- graphdb-init: a one-shot instance that creates the CMD2RDF GraphDB repository (if it does not already exist) and preloads some data.
- cmd2rdf: the container where CMD2RDF will be running for importing data into GraphDB.

You can build the Docker Compose setup with:

```docker-compose build```

You can run the containers with:

```docker-compose up -d```

This will spin up the GraphDB instance, have the graphdb-init instance wait with verification until it is considered up:

- If the CMD2RDF repository does not exist, it will be created and several files will be imported (ld subdirectory)
- If the CMD2RDF repo does exists, the script will just exit.

Then you can run software from the cmd2rdf Docker container:

- cmd2rdf-cron.sh: a shell file for downloading CLARIN harvesting results and unpacking them.
- cmd2rdf-run.sh: a shell file for importing the CLARIN harvesting results into GraphDB.

Make sure to modify the configuration of CM2RDF to point to the correct CMDI XML directory:

````vim /app/src/CMD2RDF/batch/src/main/resources/cmd2rdf.xml````