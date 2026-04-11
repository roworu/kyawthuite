ublue kinoite image + cachyos kernel


### install
to use it firstly install fedora kinoite, and switch to unsigned image first:

```bash
rpm-ostree rebase ostree-unverified-registry:ghcr.io/roworu/kinoite
```

and then after reboot switch to signed version:
```bash
rpm-ostree rebase ostree-image-signed:docker://ghcr.io/roworu/kinoite
```

for nvidia version, use nvidia image name:
```bash
rpm-ostree rebase ostree-unverified-registry:ghcr.io/roworu/kinoite-nvidia
rpm-ostree rebase ostree-image-signed:docker://ghcr.io/roworu/kinoite-nvidia
```


### secureboot
for secureboot to work, firstly import key:
```bash
mokutil --import /secureboot/MOK.der --password password
```

then, after reboot, import that key to your uefi. the password for key is `password`