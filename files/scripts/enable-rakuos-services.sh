#!/bin/sh
# Enable all RakuOS system services
systemctl enable rakuos-overlay-mount.service
systemctl enable rakuos-overlay-sync.service
systemctl enable rakuos-overlay-services.service
systemctl enable rakuos-base-protect.service
systemctl enable rakuos-pkgroot-sync.service
systemctl enable rakuos-pkgroot-services.service
systemctl enable rakuos-pkgroot-init.service
systemctl enable rakuos-pkgroot-cleanup.service
systemctl enable rakuos-flatpak-watcher.service
systemctl enable rakuos-cache-clean.service
systemctl enable rakuos-migrate.service
systemctl enable rakuos-setup.service
systemctl enable rakuos-updater.service

# Enable timer services
systemctl enable rakuos-updater.timer
systemctl enable rakuos-cache-clean.timer

# Enable user service globally
systemctl enable --global rakuos-user.service