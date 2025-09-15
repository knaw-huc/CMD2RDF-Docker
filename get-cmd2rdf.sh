#!/bin/sh

if [ $CMD2RDF_SRC = "git" ]; then
	git clone https://github.com/knaw-huc/CMD2RDF.git && cd CMD2RDF && git checkout use-graphdb
else
	$CMD2RDF_SRC
fi
