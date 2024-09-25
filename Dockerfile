FROM openlink/virtuoso-opensource-7
#openlink/vos:v0

ENV CMD2RDF_SRC  git
ENV CMD2RDF_HOST http://localhost:8080
ENV CMD2RDF_HOME /app
ENV ADMIN=admin
ENV PWD=replaceMe
RUN mkdir -p /opt/virtuoso-opensource/var/lib/virtuoso/db
ADD virtuoso.ini /opt/virtuoso-opensource/var/lib/virtuoso/db/virtuoso.ini

RUN apt-get -y update
RUN apt-get -y clean
RUN apt-get -y install supervisor
RUN apt-get -y install openjdk-8-jdk
RUN apt-get -y install maven
RUN apt-get -y install tomcat9
RUN apt-get -y install curl
RUN apt-get -y install git
RUN rm -rf /var/lib/apt/lists/*
RUN rm -rf /tmp/*
  
# pacify tomcat9
RUN ln -s /var/lib/tomcat9/server /usr/share/tomcat9/
RUN ln -s /var/lib/tomcat9/shared /usr/share/tomcat9/

# startup scripts
ADD start-tomcat9.sh /start-tomcat9.sh
ADD supervisord-tomcat9.conf /etc/supervisor/conf.d/supervisord-tomcat9.conf
  
ADD start-virtuoso.sh /start-virtuoso.sh
ADD supervisord-virtuoso.conf /etc/supervisor/conf.d/supervisord-virtuoso.conf

ADD run.sh /run.sh
RUN chmod 755 /*.sh

# make the directory structure
RUN mkdir -p /app/src && \
    mkdir -p /app/data && \
    mkdir -p /app/work && \
    mkdir -p /app/work/harvester && \
    mkdir -p /app/work/profiles-cache && \
    mkdir -p /app/work/rdf-output && \
    mkdir -p /app/work/rdf-output/temp && \
    mkdir -p /app/ld

# add the linked data sets showcasing enrichment    
ADD ld/* /app/ld/
RUN chmod 755 /app/ld/*.sh
RUN sed -i "s|http://localhost:8080|$CMD2RDF_HOST|g" /app/ld/*.graph

# move VLO orgs to the harvester dir
# NOTE: orgs isn't in the new CLAVAS
RUN mv /app/ld/meertens-VLO-orgs.rdf /app/work/harvester/meertens-VLO-orgs.rdf
  
# prime the maven cache with elda
WORKDIR /app/src
RUN git clone https://github.com/epimorphics/elda.git
WORKDIR /app/src/elda
RUN git checkout tags/elda-1.3.1
RUN mvn -DskipTests clean install

# checkout and compile cmd2rdf
#RUN git clone https://github.com/TheLanguageArchive/CMD2RDF.git
ADD get-cmd2rdf.sh /app
RUN chmod +x /app/get-cmd2rdf.sh
WORKDIR /app/src
RUN  /app/get-cmd2rdf.sh
RUN sed -i "s|/app|$CMD2RDF_HOME|g" /app/src/CMD2RDF/webapps/src/main/webapp/WEB-INF/web.xml
RUN sed -i "s|/app|$CMD2RDF_HOME|g" /app/src/CMD2RDF/batch/src/main/resources/cmd2rdf.xml
RUN sed -i "s|Put here a strong password!|$PWD|g" /app/src/CMD2RDF/batch/src/main/resources/cmd2rdf.xml
RUN sed -i "s|http://localhost:8080|$CMD2RDF_HOST|g" /app/src/CMD2RDF/batch/src/main/resources/cmd2rdf.xml
RUN sed -i "s|http://192.168.99.100:8080|$CMD2RDF_HOST|g" /app/src/CMD2RDF/lda/src/main/webapp/specs/cmd2rdf-lda.ttl
RUN sed -i "s|ADMIN|${ADMIN}|g" /app/src/CMD2RDF/webapps/src/main/java/nl/knaw/dans/cmd2rdf/webapps/ui/service/UserService.java
RUN sed -i "s|PWD|${PWD}|g" /app/src/CMD2RDF/webapps/src/main/java/nl/knaw/dans/cmd2rdf/webapps/ui/service/UserService.java
RUN rm /app/get-cmd2rdf.sh
WORKDIR /app/src/CMD2RDF
RUN mvn clean install
# once more to create webapps/target/Cmd2RdfPageHeader.properties
RUN mvn install
# install the WARs
RUN cp /app/src/CMD2RDF/webapps/target/cmd2rdf.war /var/lib/tomcat9/webapps
RUN cp /app/src/CMD2RDF/lda/target/cmd2rdf-lda.war /var/lib/tomcat9/webapps

# install the script to import CMD records
ADD cmd2rdf-init.sh /app/cmd2rdf-init.sh
ADD cmd2rdf-cron.sh /app/cmd2rdf-cron.sh
ADD cmd2rdf-run.sh /app/cmd2rdf-run.sh
RUN chmod 755 /app/*.sh

EXPOSE 1111
EXPOSE 8890
EXPOSE 8080

WORKDIR /app
CMD ["/run.sh"]
