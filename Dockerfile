# image name: windows-vm-ubuntu
FROM ubuntu:22.04

LABEL description="Windows VM in Ubuntu for Railway" \
      maintainer="your-email@example.com"

# نصب ابزارهای ضروری و ابزارهای کلیدی
RUN apt-get update -y && apt-get install -y \
    wget curl unzip gnupg2 software-properties-common \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# افزودن PPA WineHQ با روش جدید
RUN wget -q https://dl.winehq.org/wine-builds/winehq.key && \
    gpg --dearmor < winehq.key > /usr/share/keyrings/winehq-archive.key && \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/winehq-archive.key] https://dl.winehq.org/wine-builds/ubuntu/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/winehq.list && \
    apt-get update -y && \
    apt-get install -y winehq-stable && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# نصب ابزارهای ضروری برای VNC/Websockify
RUN apt-get update -y && apt-get install -y \
    x11vnc novnc websockify xvfb cabextract \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

EXPOSE 5901 6080
WORKDIR /opt/windows
CMD ["bash"]
