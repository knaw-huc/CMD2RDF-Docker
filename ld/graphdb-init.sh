#!/bin/sh
set -eu

echo "Waiting for GraphDB..."
if curl -fsS "$GDB_URL/rest/repositories/$REPO_ID" >/dev/null 2>&1; then
  echo "Repository '$REPO_ID' already exists. Nothing to do."
  exit 0
fi

echo "Creating repository '$REPO_ID'..."
curl -fsS -X POST \
     -F "config=@/app/ld/graphdb-repo.ttl" \
     "$GDB_URL/rest/repositories"
echo "Repository created."

/app/ld/graphdb_bulk_import.sh

exit 0