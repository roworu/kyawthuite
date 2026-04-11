ublue kinoite image + cachyos kernel

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