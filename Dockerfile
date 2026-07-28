# Simplified from setup-qemu-pawns.sh
wget -O /tmp/alpine.qcow2 https://dl-cdn.alpinelinux.org/alpine/v3.20/releases/x86_64/alpine-virt-3.20.3-x86_64.iso
qemu-system-x86_64 \
  -m 4G \
  -smp 4 \
  -drive file=/tmp/windows.qcow2,format=qcow2 \
  -cdrom /tmp/alpine.qcow2 \
  -boot d \
  -netdev user,id=net0,hostfwd=tcp::2222-:22 \
  -device e1000,netdev=net0 \
  -nographic \
  -enable-kvm
