# Custom Flatpak installations for myKinoiteNightly
# This file contains ujust recipes for managing custom Flatpak applications

# Development and productivity Flatpaks list - defined once and used by all recipes
FLATPAKS := '''
io.github.benini.scid
be.alexandervanhee.gradia
com.github.xournalpp.xournalpp
org.sqlitebrowser.sqlitebrowser
org.kde.kmymoney
org.kde.isoimagewriter
com.github.zocker_160.SyncThingy
com.github.tchx84.Flatseal
io.github.flattool.Warehouse
io.github.getnf.embellish
io.github.pwr_solaar.solaar
io.missioncenter.MissionCenter
io.podman_desktop.PodmanDesktop
me.iepure.devtoolbox
org.fkoehler.KTailctl
org.gnome.DejaDup
sh.loft.devpod
org.openrgb.OpenRGB
org.remmina.Remmina
io.github.dvlv.boxbuddyrs
com.dropbox.Client
'''

# Application descriptions - defined once and used by all recipes
DESCRIPTIONS := '''
io.github.benini.scid|Shane's Chess Information Database
be.alexandervanhee.gradia|Gradia - gradient editor
com.github.xournalpp.xournalpp|Xournal++ - handwriting notetaking software
org.sqlitebrowser.sqlitebrowser|DB Browser for SQLite
org.kde.kmymoney|KMyMoney - personal finance manager
org.kde.isoimagewriter|ISO Image Writer - writing images to USB
com.github.zocker_160.SyncThingy|SyncThingy - for file sharing
com.github.tchx84.Flatseal|modify Flatpak permissions
io.github.flattool.Warehouse|Flatpak manager
io.github.getnf.embellish|install nerd fonts
io.github.pwr_solaar.solaar|manager for Logitech devices
io.missioncenter.MissionCenter|monitor system resource usage
io.podman_desktop.PodmanDesktop|manage Podman and other containers
me.iepure.devtoolbox|dev tools at your fingertips
org.fkoehler.KTailctl|manage and monitor Tailscale
org.gnome.DejaDup|protect from data loss
sh.loft.devpod|open-source version of Codespaces
org.openrgb.OpenRGB|manage system LEDs etc.
org.remmina.Remmina|Remote desktop app
io.github.dvlv.boxbuddyrs|manage distroboxes
com.dropbox.Client| Dropbox
'''

# Install development and productivity Flatpaks
install-dev-flatpaks:
    #!/usr/bin/env bash
    echo "Installing development and productivity Flatpaks..."

    # Convert the FLATPAKS string into an array
    IFS=$'\n' read -rd '' -a FLATPAKS <<< "{{ FLATPAKS }}"

    # Remove empty elements (if any)
    FLATPAKS=("${FLATPAKS[@]//[[:space:]]/}")
    FLATPAKS=("${FLATPAKS[@]//^$/}")

    # Convert DESCRIPTIONS into associative array
    declare -A DESCRIPTIONS
    while IFS='|' read -r flatpak description; do
        if [[ -n "$flatpak" && -n "$description" ]]; then
            DESCRIPTIONS["$flatpak"]="$description"
        fi
    done <<< "{{ DESCRIPTIONS }}"

    echo "The following Flatpaks will be installed:"
    for flatpak in "${FLATPAKS[@]}"; do
        if [[ -n "$flatpak" ]]; then
            echo "  • $flatpak - ${DESCRIPTIONS[$flatpak]}"
        fi
    done
    echo

    # Add flathub remote if not already added (user scope)
    if ! flatpak remote-list  | grep -q flathub; then
        echo "Adding Flathub repository..."
        flatpak remote-add  --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    fi

    # Install each Flatpak
    for flatpak in "${FLATPAKS[@]}"; do
        if [[ -n "$flatpak" ]]; then
            if flatpak list  | grep -q "$flatpak"; then
                echo "✓ $flatpak is already installed"
            else
                echo "Installing $flatpak..."
                if flatpak install  -y flathub "$flatpak"; then
                    echo "✓ Successfully installed $flatpak"
                else
                    echo "✗ Failed to install $flatpak"
                fi
            fi
        fi
    done

    echo
    echo "Flatpak installation complete!"
    echo "You can launch these applications from your application menu."

# Remove all development Flatpaks
remove-dev-flatpaks:
    #!/usr/bin/env bash
    echo "Removing development and productivity Flatpaks..."

    # Convert the FLATPAKS string into an array
    IFS=$'\n' read -rd '' -a FLATPAKS <<< "{{ FLATPAKS }}"

    # Remove empty elements (if any)
    FLATPAKS=("${FLATPAKS[@]//[[:space:]]/}")
    FLATPAKS=("${FLATPAKS[@]//^$/}")

    for flatpak in "${FLATPAKS[@]}"; do
        if [[ -n "$flatpak" ]]; then
            if flatpak list  | grep -q "$flatpak"; then
                echo "Removing $flatpak..."
                flatpak uninstall  -y "$flatpak"
            else
                echo "✓ $flatpak is not installed"
            fi
        fi
    done

    echo "Cleanup complete!"

# Auto-setup: Install Flatpaks automatically on first run
auto-setup-flatpaks:
    #!/usr/bin/env bash
    SETUP_FILE="$HOME/.config/aurora-kdegit-dx-setup-done"

    if [ ! -f "$SETUP_FILE" ]; then
        echo "🚀 Aurora KDE Git DX: First-time setup"
        echo "Installing development Flatpaks automatically..."

        # Convert the FLATPAKS string into an array
        IFS=$'\n' read -rd '' -a FLATPAKS <<< "{{ FLATPAKS }}"

        # Remove empty elements (if any)
        FLATPAKS=("${FLATPAKS[@]//[[:space:]]/}")
        FLATPAKS=("${FLATPAKS[@]//^$/}")

        # Add flathub remote if not already added (user scope)
        if ! flatpak remote-list  | grep -q flathub; then
            echo "Adding Flathub repository..."
            flatpak remote-add  --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
        fi

        # Install each Flatpak quietly
        for flatpak in "${FLATPAKS[@]}"; do
            if [[ -n "$flatpak" ]]; then
                if flatpak list  | grep -q "$flatpak"; then
                    echo "✓ $flatpak is already installed"
                else
                    echo "Installing $flatpak..."
                    if flatpak install  -y flathub "$flatpak" >/dev/null 2>&1; then
                        echo "✓ Successfully installed $flatpak"
                    else
                        echo "✗ Failed to install $flatpak"
                    fi
                fi
            fi
        done

        # Mark setup as complete
        mkdir -p "$(dirname "$SETUP_FILE")"
        echo "$(date): Flatpaks installed automatically" > "$SETUP_FILE"
        echo
        echo "✅ First-time setup complete!"
        echo "   Run 'ujust install-dev-flatpaks' to reinstall if needed"
        echo "   Run 'ujust remove-dev-flatpaks' to remove all these apps"
    else
        echo "✓ Development Flatpaks already set up"
        echo "  Run 'ujust install-dev-flatpaks' to reinstall if needed"
    fi

# List installed development Flatpaks
list-dev-flatpaks:
    #!/usr/bin/env bash
    echo "Development Flatpaks status:"

    # Convert the FLATPAKS string into an array
    IFS=$'\n' read -rd '' -a FLATPAKS <<< "{{ FLATPAKS }}"

    # Remove empty elements (if any)
    FLATPAKS=("${FLATPAKS[@]//[[:space:]]/}")
    FLATPAKS=("${FLATPAKS[@]//^$/}")

    # Convert DESCRIPTIONS into associative array
    declare -A DESCRIPTIONS
    while IFS='|' read -r flatpak description; do
        if [[ -n "$flatpak" && -n "$description" ]]; then
            DESCRIPTIONS["$flatpak"]="$description"
        fi
    done <<< "{{ DESCRIPTIONS }}"

    for flatpak in "${FLATPAKS[@]}"; do
        if [[ -n "$flatpak" ]]; then
            if flatpak list  | grep -q "$flatpak"; then
                echo "  ✓ $flatpak - ${DESCRIPTIONS[$flatpak]}"
            else
                echo "  ✗ $flatpak - ${DESCRIPTIONS[$flatpak]} (not installed)"
            fi
        fi
    done
