#!/bin/bash
set -e

GRAPHDB_URL=http://localhost:7200
REPO_ID=clarin
CONFIG_FILE=/app/graphdb/graphdb-clarin-repo.ttl

until curl -s "$GRAPHDB_URL/rest/repositories" > /dev/null; do
    echo "Waiting for GraphDB..."
    sleep 2
done

if curl -s "$GRAPHDB_URL/rest/repositories" | grep -q "\"id\" *: *\"$REPO_ID\""; then
    echo "Repository $REPO_ID already exists"
else
    echo "Creating repository '$REPO_ID'..."
    curl -X POST -H "Content-Type: multipart/form-data" \
                 -F "config=@$CONFIG_FILE" \
                 "$GRAPHDB_URL/rest/repositories"
fi

exit 0