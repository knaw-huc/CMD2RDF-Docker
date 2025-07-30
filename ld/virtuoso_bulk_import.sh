#!/bin/sh
echo "Executing bulk loader script."
echo "Host / port: virtuoso:1111"
echo "username: dba"
echo "password: dba"
echo "rdf directory: /app/ld"

isql virtuoso:1111 dba dba exec="ld_dir_all('/app/ld', '*.n3', 'http://eko.indarto/eko.rdf');"
isql virtuoso:1111 dba dba exec="ld_dir_all('/app/ld', '*.rdf', 'http://eko.indarto/eko.rdf');"
isql virtuoso:1111 dba dba exec="rdf_loader_run();"
isql virtuoso:1111 dba dba exec="checkpoint;"

echo "Bulk loader: Finished."
