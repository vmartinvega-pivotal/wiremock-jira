FROM openjdk:8-jre

LABEL maintainer="Vicente Martin Vega"

#ENV WIREMOCK_VERSION 2.29.0

# grab wiremock standalone jar
#RUN mkdir -p /var/wiremock/lib/ \
#  && wget https://repo1.maven.org/maven2/com/github/tomakehurst/wiremock-jre8-standalone/$WIREMOCK_VERSION/wiremock-jre8-standalone-$WIREMOCK_VERSION.jar \
#    -O /var/wiremock/lib/wiremock-jre8-standalone.jar

RUN mkdir -p /var/wiremock/lib \
    && mkdir -p /var/wiremock/extensions

COPY binaries/wiremock-jre8-standalone.jar /var/wiremock/lib/wiremock-jre8-standalone.jar

WORKDIR /home/wiremock

COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

VOLUME /home/wiremock
EXPOSE 8080 8443

COPY stubs /home/wiremock

USER 20000

ENTRYPOINT ["/docker-entrypoint.sh"]