#!/usr/bin/env bash

set -ouex pipefail

# setup repos
dnf5 config-manager addrepo \
  --from-repofile=https://negativo17.org/repos/fedora-nvidia.repo \
  && sed -i '/^enabled=/a\priority=90' /etc/yum.repos.d/fedora-nvidia.repo
dnf5 config-manager addrepo \
  --from-repofile=https://nvidia.github.io/libnvidia-container/stable/rpm/nvidia-container-toolkit.repo

dnf5 config-manager setopt "*rpmfusion*".enabled=0
dnf5 config-manager setopt fedora-nvidia.enabled=0

# akmods and prepare for build
dnf5 -y install --enablerepo=fedora-nvidia akmod-nvidia
mkdir -p /var/tmp
chmod 1777 /var/tmp
KVER=$(ls /usr/lib/modules | head -n1)
akmods --force --kernels "${KVER}" --kmod "nvidia"
cat /var/cache/akmods/nvidia/*.failed.log || true

# nvidia driver repo
packages=(
  nvidia-driver-cuda
  libnvidia-fbc
  libva-nvidia-driver
  nvidia-driver
  nvidia-modprobe
  nvidia-persistenced
  nvidia-settings
)

# nvidia driver install 
dnf5 -y install --enablerepo=fedora-nvidia "${packages[@]}"
dnf5 versionlock add "${packages[@]}"

# nvidia container toolkit 

dnf5 config-manager setopt nvidia-container-toolkit.enabled=0
dnf5 config-manager setopt nvidia-container-toolkit.gpgcheck=1
dnf5 -y install --enablerepo=nvidia-container-toolkit \
    nvidia-container-toolkit

# selinux
curl --retry 3 -L https://raw.githubusercontent.com/NVIDIA/dgx-selinux/master/bin/RHEL9/nvidia-container.pp -o nvidia-container.pp
semodule -i nvidia-container.pp
rm -f nvidia-container.pp
rm /etc/xdg/autostart/nvidia-settings-load.desktop

systemctl enable nvctk-cdi.service

preset_file="/usr/lib/systemd/system-preset/01-kyawthuite.preset"
touch "$preset_file"
echo "enable nvctk-cdi.service" >> "$preset_file"

echo "::endgroup::"
