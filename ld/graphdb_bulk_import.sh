#!/usr/bin/env bash
set -euo pipefail

GRAPHDB_URL="http://graphdb:7200"
REPO_ID="cmd2rdf"
GRAPH_URI="http://eko.indarto/eko.rdf"

echo "Uploading *.n3 as text/n3..."
for f in /app/ld/*.n3; do
  [ -e "$f" ] || continue
  echo " -> $f"
  curl -s -X POST \
    -H "Content-Type: text/n3" \
    --data-binary @"$f" \
    "$GRAPHDB_URL/repositories/$REPO_ID/statements?context=%3C${GRAPH_URI//\//%2F}%3E"
done

echo "Uploading *.rdf as application/rdf+xml..."
for f in /app/ld/*.rdf; do
  [ -e "$f" ] || continue
  echo " -> $f"
  curl -s -X POST \
    -H "Content-Type: application/rdf+xml" \
    --data-binary @"$f" \
    "$GRAPHDB_URL/repositories/$REPO_ID/statements?context=%3C${GRAPH_URI//\//%2F}%3E"
done

echo "Finished."