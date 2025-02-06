FROM cgr.dev/chainguard/jre:latest-dev

USER root
RUN apk update && apk add curl libudev
RUN adduser --system minecraft
WORKDIR /usr/share/minecraft

RUN curl -O https://piston-data.mojang.com/v1/objects/4707d00eb834b446575d89a61a11b5d548d8c001/server.jar
RUN java -jar server.jar nogui
RUN sed -i 's/false/true/' eula.txt

COPY build-config.sh /usr/share/minecraft/build-config.sh
RUN chmod +x /usr/share/minecraft/build-config.sh

RUN chown -R minecraft /usr/share/minecraft
USER minecraft

ENTRYPOINT ["/usr/share/minecraft/build-config.sh", "java", "-jar" , "/usr/share/minecraft/server.jar", "nogui"]