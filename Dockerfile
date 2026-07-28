# image name: windows-vm-ubuntu
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive \
    VNC_PORT=5901 \
    WEBSOCKIFY_PORT=6080 \
    DISPLAY=:99

RUN apt-get update && \
    apt-get install -y wget curl unzip xvfb x11vnc novnc websockify wine-stable cabextract && \
    wget -q https://dl.winehq.org/wine-builds/winehq.key && \
    apt-key add winehq.key && \
    add-apt-repository -y ppa:winehq/ppa && \
    apt-get update && \
    apt-get install -y winehq-stable && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /opt/vnc/
RUN chmod +x /opt/vnc/entrypoint.sh

WORKDIR /opt/windows
EXPOSE 5901 6080
ENTRYPOINT ["/opt/vnc/entrypoint.sh"]
CMD ["bash"]
