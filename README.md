[![kyawthuite build status](https://github.com/roworu/kyawthuite/actions/workflows/build.yml/badge.svg)](https://github.com/roworu/kyawthuite/actions/workflows/build.yml)

<div align="center">
  <picture>
    <source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/roworu/kyawthuite/refs/heads/main/repo_files/kyawthuite-logo-dark.png">
    <img alt="kyawthuite logo" src="https://raw.githubusercontent.com/roworu/kyawthuite/refs/heads/main/repo_files/kyawthuite-logo-light.png" width="200">
  </picture>
</div>

# kyawthuite
kyawthuite - minimal, performant, and stable desktop OS based on Fedora, Bazzite and Universal Blue technologies

kyawthuite (pronounced as "kyatuit") - named after the [Kyawthuite](https://wikipedia.org/wiki/Kyawthuite) mineral, a rare natural bismuth antimonate (BiSbO₄) known for its **stability and distinct crystalline structure**.

## base System

- built on Fedora 42
- uses [Bazzite](https://bazzite.gg/) as the base image
- Hyprland inegrated

# installation

you you already running Fedora atomic or UBlue based distribution:
```bash
sudo bootc switch --enforce-container-sigpolicy ghcr.io/roworu/kyawthuite:latest
```

if you want to install kyawthuite as a new system, you will have to firstly install Bazzite:
```
https://download.bazzite.gg/bazzite-stable-amd64.iso
```

fully featured iso files coming soon..