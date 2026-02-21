#!/usr/bin/env bash

log() {
    local level="info"
    if [[ "${1:-}" == "error" ]]; then
        level="error"
        shift
    fi

    if [[ "$level" == "error" ]]; then
        printf "%b\n" "${\033[1;31m}$*${\033[0m}"
    else
        printf "%b\n" "${\033[1;34m}$*${\033[0m}"
    fi
}

sys-update() {
    log "==> Checking bootc..."
    output=$(sudo bootc upgrade --check || true)

    if echo "$output" | grep -qi "update available"; then
        version=$(echo "$output" | awk -F': ' '/Version:/ {print $2}')
        if [[ -z "${version:-}" ]]; then
            log error "Unable to determine bootc update version. Please run: sudo bootc upgrade --check"
            return 1
        fi
        log "bootc update available: ${version}"
    else
        log "bootc: up to date"
    fi

    log "==> Checking flatpak..."
    flatpak_output=$(flatpak remote-ls --updates 2>&1)
    flatpak_status=$?
    if [[ $flatpak_status -ne 0 ]]; then
        log error "Unable to check flatpak updates. Please run: flatpak remote-ls --updates"
        return 1
    fi
    flatpak_updates=$(printf '%s\n' "$flatpak_output" | wc -l | tr -d ' ')
    if [[ ! "$flatpak_updates" =~ ^[0-9]+$ ]]; then
        log error "Unable to count flatpak updates. Please run: flatpak remote-ls --updates"
        return 1
    fi
    if [[ "$flatpak_updates" -eq 0 ]]; then
        log "flatpak: no updates"
    else
        log "flatpak updates: $flatpak_updates"
    fi

    log "==> Checking brew..."
    if ! brew update >/dev/null 2>&1; then
        log error "Unable to update brew metadata. Please run: brew update"
        return 1
    fi
    brew_output=$(brew outdated 2>&1)
    brew_status=$?
    if [[ $brew_status -ne 0 ]]; then
        log error "Unable to count brew updates. Please run: brew outdated"
        return 1
    fi
    brew_updates=$(printf '%s\n' "$brew_output" | wc -l | tr -d ' ')
    if [[ ! "$brew_updates" =~ ^[0-9]+$ ]]; then
        log error "Unable to count brew updates. Please run: brew outdated"
        return 1
    fi
    if [[ "$brew_updates" -eq 0 ]]; then
        log "brew: no updates"
    else
        log "brew updates: $brew_updates"
    fi
}

sys-upgrade() {

    log "==> Upgrading bootc..."
    sudo bootc upgrade

    log "==> Upgrading flatpak..."
    flatpak update -y

    log "==> Upgrading brew..."
    brew upgrade --refresh

    log "==> Upgrade complete!"
}

sys-upgrade-reboot() {
    upgrade
    log "==> Rebooting..."
    sudo reboot
}

# to use it, call these functions directly from shell, like that:
# > sys-update