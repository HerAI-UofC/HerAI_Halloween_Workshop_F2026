FROM ubuntu:24.04
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
      ttyd procps nano less util-linux ca-certificates \
 && rm -rf /var/lib/apt/lists/*

RUN useradd -m -s /bin/bash guest

COPY build_house.sh ghost_ai.sh entrypoint.sh /tmp/setup/

RUN bash /tmp/setup/build_house.sh \
 && install -m 755 /tmp/setup/ghost_ai.sh /opt/ghost_ai.sh \
 && install -m 755 /tmp/setup/entrypoint.sh /entrypoint.sh \
 && rm -rf /tmp/setup

EXPOSE 7681
ENTRYPOINT ["/entrypoint.sh"]