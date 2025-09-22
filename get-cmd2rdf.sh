#!/bin/sh

if [ $CMD2RDF_SRC = "git" ]; then
	git clone --branch use-graphdb https://github.com/knaw-huc/CMD2RDF.git
else
	$CMD2RDF_SRC
fi
