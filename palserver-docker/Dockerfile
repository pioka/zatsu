FROM docker.io/steamcmd/steamcmd:latest

RUN \
  steamcmd +login anonymous +app_update 2394010 validate +quit && \
  chown -R nobody .

WORKDIR /root/Steam/steamapps/common/PalServer

USER nobody
ENTRYPOINT ["./PalServer.sh"]
