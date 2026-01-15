#!/bin/bash

set -ouex pipefail

# Workaround for:
# error: Checkout kde-beta: opendir(kde-beta): No such file or directory
# https://github.com/blue-build/bluebuild/issues/1435
# https://github.com/coreos/rpm-ostree/issues/4187
mkdir -p /var/lib/alternatives

COPR_URL="https://copr.fedorainfracloud.org/coprs/g/kdesig/kde-beta/repo/fedora-43/group_kdesig-kde-beta-fedora-43.repo"
COPR_NAME="copr:copr.fedorainfracloud.org:group_kdesig:kde-beta"
REPO_FILE="/etc/yum.repos.d/kde-beta.repo"

# 1. Enable the COPR so dnf can query it
curl -L -o "$REPO_FILE" "$COPR_URL"

# 2. Get the list of all packages in the COPR
echo "Querying COPR for packages..."
# We use dnf repoquery to get the list of package NAMES present in the repo
AVAILABLE_PACKAGES=$(dnf repoquery --disablerepo='*' --enablerepo="$COPR_NAME" --arch=x86_64,noarch --exclude='*-debuginfo,*-debugsource' --qf '%{name}\n' | sort -u)

if [ -z "$AVAILABLE_PACKAGES" ]; then
    echo "Error: No packages found in COPR repository!"
    exit 1
fi

# 3. Find which of these packages are currently installed in the base image
echo "Identifying installed packages to replace..."
PACKAGES_TO_REPLACE=""

for pkg in $AVAILABLE_PACKAGES; do
    if rpm -q "$pkg" > /dev/null 2>&1; then
        # Get the architecture of the installed package
        ARCH=$(rpm -q --queryformat '%{ARCH}' "$pkg")
        echo "  - Marking for replacement: $pkg ($ARCH)"
        PACKAGES_TO_REPLACE="$PACKAGES_TO_REPLACE ${pkg}.${ARCH}"
    fi
done

if [ -z "$PACKAGES_TO_REPLACE" ]; then
    echo "No matching packages found to replace."
    exit 0
fi

# 4. Perform the massive override replace
# We use the --from repo argument to pull the packages directly from the COPR
# 4. Download and replace
echo "Downloading packages from COPR..."
DOWNLOAD_DIR=$(mktemp -d)
dnf download --disablerepo='*' --enablerepo="$COPR_NAME" \
    --destdir="$DOWNLOAD_DIR" \
    --exclude='*-debuginfo,*-debugsource' \
    $PACKAGES_TO_REPLACE

# Remove any source packages that may have been downloaded
rm -f "$DOWNLOAD_DIR"/*.src.rpm

if [ -z "$(ls -A $DOWNLOAD_DIR)" ]; then
    echo "Error: Failed to download packages."
    exit 1
fi

echo "Executing rpm-ostree override replace with downloaded packages..."
rpm-ostree override replace \
    --experimental \
    $DOWNLOAD_DIR/*.x86_64.rpm \
    $DOWNLOAD_DIR/*.noarch.rpm

rm -rf "$DOWNLOAD_DIR"
