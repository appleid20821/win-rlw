# image name: windows-vm-ubuntu
FROM ubuntu:22.04

LABEL description="Windows VM in Ubuntu for Railway" \
      maintainer="your-email@example.com" \
      version="1.0" \
      platform="linux/amd64" \
      windows_version="10" \
      virtualization="QEMU+WINE"

# نصب ابزارهای ضروری از جمله gnupg
RUN apt-get update -y && \
    apt-get install -y \
        wget \
        curl \
        unzip \
        gnupg2 \
        software-properties-common && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# افزودن کلید WineHQ با استفاده از روش جدید (SSH)
RUN wget -q https://dl.winehq.org/wine-builds/winehq.key && \
    apt-key add winehq.key && \
    add-apt-repository -y ppa:winehq/ppa && \
    apt-get update -y && \
    apt-get install -y winehq-stable && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# نصب ابزارهای ضروری برای VNC/Websockify
RUN apt-get update -y && \
    apt-get install -y \
        xvfb \
        x11vnc \
        novnc \
        websockify \
        cabextract && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# آماده‌سازی دایرکتوری‌های ضروری و پیکربندی
RUN mkdir -p /opt/wine && \
    mkdir -p /opt/vnc && \
    chown -R root:root /opt/wine && \
    chown -R root:root /opt/vnc && \
    chmod 755 /opt/wine && \
    chmod 755 /opt/vnc

# کپی پایگاه داده Wine (اختیاری)
COPY wine.db /opt/wine/ || true

WORKDIR /opt/windows
EXPOSE 5901 6080
CMD ["bash"]
