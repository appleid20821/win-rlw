# image name: windows-vm-ubuntu
FROM ubuntu:22.04

LABEL description="Windows VM in Ubuntu for Railway" \
      maintainer="your-email@example.com" \
      version="1.0" \
      platform="linux/amd64" \
      windows_version="11" \
      virtualization="QEMU+WINE"

# نصب GNU Power Tools و ImageMagick
RUN apt-get update -y && \
    apt-get install -y \
        wget \
        curl \
        unzip \
        gnupg2 \
        software-properties-common \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# اضافه کردن بندهای PPA WineHQ فقط برای amd64
RUN wget -q https://dl.winehq.org/wine-builds/winehq.key && \
    gpg --dearmor < winehq.key > /usr/share/keyrings/winehq-archive.key && \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/winehq-archive.key] https://dl.winehq.org/wine-builds/ubuntu/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/winehq.list && \
    apt-get update -y && \
    apt-get install -y --no-install-recommends winehq-stable && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# نصب ابزارهای ضروری برای VNC/Websockify
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
        x11vnc \
        novnc \
        websockify \
        xvfb \
        cabextract \
        imagemagick && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# حذف ابزارهای یکبار مصرف
RUN rm -f winehq.key

# ایجاد دایرکتوری‌های ضروری
RUN mkdir -p /opt/wine && \
    mkdir -p /opt/vnc && \
    chown -R root:root /opt/wine && \
    chown -R root:root /opt/vnc && \
    chmod 755 /opt/wine && \
    chmod 755 /opt/vnc

# پیکربندی Wine (اختیاری)
RUN echo "[ شرکت عام ]\nHKLM\n[ key \\Software\\Wine\\Direct3D ]\n# تنظیمات برای اجرای بهتر در مجازی سازی" > /opt/wine/system.reg

# پورت‌ها را برای اتصال اعلان کنید
EXPOSE 5901 6080

# ایجاد فایل entrypoint خودکارسروی
RUN cat > /opt/vnc/entrypoint.sh << 'EOF'
#!/bin/bash

# شروع Xvfb برای GUI
Xvfb :99 -screen 0 1024x768x24 &

# شروع x11vnc برای دسترسی VNC (پورت 5901)
x11vnc -display \$DISPLAY -listen 0.0.0.0 -passwdfile /root/.x11vnc.passwd -rfw -shared -localhost no

# websockify برای اتصال WebVNC
websockify -D --web=/usr/share/novnc/ 6080 localhost:5901

# نگه داشتن کانتینر زنده بماند
wait
EOF

RUN chmod +x /opt/vnc/entrypoint.sh

WORKDIR /opt/windows

# شروع خودکار با استفاده از entrypoint
ENTRYPOINT ["/opt/vnc/entrypoint.sh"]
CMD ["bash"]
