#!/usr/bin/bash

set -eoux pipefail

firmware="linux-firmware-whence qcom-wwan-firmware linux-firmware amd-gpu-firmware amd-ucode-firmware atheros-firmware brcmfmac-firmware cirrus-audio-firmware intel-audio-firmware intel-gpu-firmware intel-vsc-firmware iwlegacy-firmware iwlwifi-dvm-firmware iwlwifi-mvm-firmware libertas-firmware mt7xxx-firmware nvidia-gpu-firmware nxpwireless-firmware realtek-firmware tiwilink-firmware"
dnf5 -y remove --no-autoremove $firmware
dnf5 -y install --repo="copr:copr.fedorainfracloud.org:bazzite-org:bazzite" $firmware

git clone https://github.com/hhd-dev/hwfirm /tmp/hwfirm --depth 1
cp -r /tmp/hwfirm/cirrus/* /usr/lib/firmware/cirrus/
cp -r /tmp/hwfirm/rtl_bt/* /usr/lib/firmware/rtl_bt/
cp -r /tmp/hwfirm/awinic/* /usr/lib/firmware/
rm -rf /tmp/hwfirm/

rm /usr/lib/firmware/rtl_bt/rtl8822cu_config.bin.xz

dnf5 -y remove --no-autoremove kernel kernel-core kernel-modules kernel-modules-core kernel-modules-extra kernel-tools kernel-tools-libs kernel-uki-virt

dnf5 -y install \
    /tmp/kernel-rpms/kernel-[0-9]*.rpm \
    /tmp/kernel-rpms/kernel-core-*.rpm \
    /tmp/kernel-rpms/kernel-modules-*.rpm \
    /tmp/kernel-rpms/kernel-tools-[0-9]*.rpm \
    /tmp/kernel-rpms/kernel-tools-libs-[0-9]*.rpm \
    /tmp/kernel-rpms/kernel-devel-*.rpm

dnf5 versionlock add kernel kernel-devel kernel-devel-matched kernel-core kernel-modules kernel-modules-core kernel-modules-extra kernel-tools kernel-tools-libs

dnf5 -y install \
    /tmp/akmods-rpms/kmods/*kvmfr*.rpm \
    /tmp/akmods-rpms/kmods/*xone*.rpm \
    /tmp/akmods-rpms/kmods/*openrazer*.rpm \
    /tmp/akmods-rpms/kmods/*v4l2loopback*.rpm \
    /tmp/akmods-rpms/kmods/*wl*.rpm \
    /tmp/akmods-rpms/kmods/*framework-laptop*.rpm \
    /tmp/akmods-extra-rpms/kmods/*nct6687*.rpm \
    /tmp/akmods-extra-rpms/kmods/*gcadapter_oc*.rpm \
    /tmp/akmods-extra-rpms/kmods/*zenergy*.rpm \
    /tmp/akmods-extra-rpms/kmods/*vhba*.rpm \
    /tmp/akmods-extra-rpms/kmods/*gpd-fan*.rpm \
    /tmp/akmods-extra-rpms/kmods/*ayaneo-platform*.rpm \
    /tmp/akmods-extra-rpms/kmods/*ayn-platform*.rpm \
    /tmp/akmods-extra-rpms/kmods/*bmi260*.rpm \
    /tmp/akmods-extra-rpms/kmods/*ryzen-smu*.rpm
