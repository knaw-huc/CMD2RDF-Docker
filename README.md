# CMD2RDF-Docker
Docker Compose setup for CMD2RDF.

This Docker Compose setup defines 3 containers:

- cmd2rdf: the container where CMD2RDF will be running for importing data into GraphDB. Always started.
- graphdb: a GraphDB instance. Only started under the `cmd2rdf-local` profile.
- graphdb-init: a one-shot instance that creates the `ost-clarin-skg` GraphDB repository (if it does not already exist) and preloads some data. Only started under the `cmd2rdf-local` profile.

By default (no profile), only the `cmd2rdf` container is started and it is expected to talk to an externally hosted GraphDB. Override the target via the `GDB_URL` and `REPO_ID` environment variables (defaults: `http://graphdb:7200` and `ost-clarin-skg`).

You can build the Docker Compose setup with:

```docker-compose build```

To run only the CMD2RDF container against an external GraphDB:

```docker-compose up -d```

To run the full local stack (CMD2RDF + a local GraphDB and its initialiser), enable the `cmd2rdf-local` profile:

```docker-compose --profile cmd2rdf-local up -d```

When the `cmd2rdf-local` profile is active, this will spin up the GraphDB instance and have the graphdb-init container wait until GraphDB is healthy:

- If the `ost-clarin-skg` repository does not exist, it will be created and the files in the `ld` subdirectory will be imported.
- If the repository already exists, the script will just exit.

Then you can run software from the cmd2rdf Docker container:

- cmd2rdf-cron.sh: a shell file for downloading CLARIN harvesting results and unpacking them.
- cmd2rdf-run.sh: a shell file for importing the CLARIN harvesting results into GraphDB.
- cmd2rdf-init.sh: a shell file for creating the repo in GraphDB (if needed).

Make sure to modify the configuration of CM2RDF to point to the correct CMDI XML directory:

````vim /app/src/CMD2RDF/batch/src/main/resources/cmd2rdf.xml````