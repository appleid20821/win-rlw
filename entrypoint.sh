#!/bin/bash

# شروع Xvfb برای رابط گرافیکی
Xvfb :99 -screen 0 1024x768x24 &

# نصب Wine را اجرا کنید (اگر نیاز به نصب دوباره باشد)
# wine --version > /dev/null || wine setup

# شروع VNC در پورت 5901
x11vnc -display $DISPLAY -storepasswd password /root/.x11vnc.passwd -listen 0.0.0.0 -rfw -shared

# راه‌اندازی websockify برای اتصال از طریق مرورگر
websockify -D --web=/usr/share/novnc/ --cert=/root/self.pem $WEBSOCKIFY_PORT localhost:$VNC_PORT

# اجازه اجرای نامحدود را دهید
wait
