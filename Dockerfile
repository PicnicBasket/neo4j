## Neo4J dependency: dockerfile/java
## get java from trusted build
FROM dockerfile/java
MAINTAINER Picnic Software

## install neo4j according to http://www.neo4j.org/download/linux
# Import neo4j signing key
# Create an apt sources.list file
# Find out about the files in neo4j repo ; install neo4j community edition

RUN wget -O - http://debian.neo4j.org/neotechnology.gpg.key | apt-key add - && \
    echo 'deb http://debian.neo4j.org/repo stable/' > /etc/apt/sources.list.d/neo4j.list && \
    apt-get update ; apt-get install neo4j=2.2.0 -y

## add launcher and set execute property
## clean sources
# enable shell server on all network interfaces

ADD launch.sh /
RUN chmod +x /launch.sh && \
    apt-get clean && \
    echo "remote_shell_host=0.0.0.0" >> /var/lib/neo4j/conf/neo4j.properties && \
    echo "execution_guard_enabled=true" >> /var/lib/neo4j/conf/neo4j.properties && \
    echo "dbms.cypher.planner=RULE" >> /var/lib/neo4j/conf/neo4j.properties && \
    echo "dbms.security.auth_enabled=false" >> /var/lib/neo4j/conf/neo4j-server.properties && \
    echo "org.neo4j.server.webserver.limit.executiontime=30000" >> /var/lib/neo4j/conf/neo4j-server.properties && \

VOLUME /var/lib/neo4j/data

WORKDIR /

## entrypoint
CMD ["/bin/bash", "-c", "/launch.sh"]

