#!/bin/sh
set -eu

ENCODED_URI=$(printf '%s' "$INIT_GRAPH_URI" | sed 's|/|%2F|g')

echo "Uploading *.n3 as text/n3..."
for f in /app/ld/*.n3; do
  [ -e "$f" ] || continue
  echo " -> $f"
  curl -s -X POST \
    -H "Content-Type: text/n3" \
    --data-binary @"$f" \
    "$GDB_URL/repositories/$REPO_ID/statements?context=%3C${ENCODED_URI}%3E"
done

echo "Uploading *.rdf as application/rdf+xml..."
for f in /app/ld/*.rdf; do
  [ -e "$f" ] || continue
  echo " -> $f"
  curl -s -X POST \
    -H "Content-Type: application/rdf+xml" \
    --data-binary @"$f" \
    "$GDB_URL/repositories/$REPO_ID/statements?context=%3C${ENCODED_URI}%3E"
done

echo "Finished."