#!/bin/sh
systemctl enable rakuos-overlay-mount.service
systemctl enable rakuos-overlay-sync.service
systemctl enable rakuos-overlay-services.service
systemctl enable rakuos-base-protect.service
systemctl enable --global rakuos-user.service