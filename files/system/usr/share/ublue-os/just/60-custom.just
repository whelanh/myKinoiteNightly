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
org.openrgb.OpenRGB
org.remmina.Remmina
io.github.dvlv.boxbuddyrs
com.dropbox.Client
org.mozilla.firefox
it.mijorus.gearlever
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
org.openrgb.OpenRGB|manage system LEDs etc.
org.remmina.Remmina|Remote desktop app
io.github.dvlv.boxbuddyrs|manage distroboxes
com.dropbox.Client| Dropbox
org.mozilla.firefox| Firefox
it.mijorus.gearlever| For managing AppImages
'''

# Install Aurora CLI tools via Homebrew bundle
install-aurora-brew-bundle:
    #!/usr/bin/env bash
    echo "Installing Aurora CLI tools via Homebrew bundle..."
    
    # Check if Homebrew is available
    if ! command -v brew >/dev/null 2>&1; then
        echo "✗ Homebrew is not installed or not in PATH"
        echo "Please install Homebrew first by running:"
        echo "  ujust install-homebrew"
        echo
        echo "Then restart your terminal or run: source ~/.bashrc"
        exit 1
    fi
    
    echo "✓ Homebrew found: $(brew --version | head -n1)"
    echo
    
    # Check if the Brewfile exists
    BREWFILE="/usr/share/ublue-os/homebrew/aurora-cli.Brewfile"
    if [[ ! -f "$BREWFILE" ]]; then
        echo "✗ Aurora CLI Brewfile not found at: $BREWFILE"
        echo "This file should be provided by your Aurora system image."
        exit 1
    fi
    
    echo "✓ Found Aurora CLI Brewfile: $BREWFILE"
    echo "Installing packages from Aurora CLI bundle..."
    echo
    
        # Run brew bundle with the Aurora CLI Brewfile
    if brew bundle --file "$BREWFILE"; then
        echo
        echo "✅ Aurora CLI tools installed successfully!"
        echo "All tools from the Aurora CLI bundle are now available."
    else
        echo
        echo "✗ Failed to install some packages from Aurora CLI bundle"
        echo "Check the error messages above for details"
        exit 1
    fi

# Install Aurora fonts via Homebrew bundle
install-fonts:
    #!/usr/bin/env bash
    echo "Installing Aurora fonts via Homebrew bundle..."
    
    # Check if Homebrew is available
    if ! command -v brew >/dev/null 2>&1; then
        echo "✗ Homebrew is not installed or not in PATH"
        echo "Please install Homebrew first by running:"
        echo "  ujust install-homebrew"
        echo
        echo "Then restart your terminal or run: source ~/.bashrc"
        exit 1
    fi
        
    echo "✓ Homebrew found: $(brew --version | head -n1)"
    echo
        
    # Check if the Brewfile exists
    BREWFILE="/usr/share/ublue-os/homebrew/aurora-fonts.Brewfile"
    if [[ ! -f "$BREWFILE" ]]; then
        echo "✗ Aurora fonts Brewfile not found at: $BREWFILE"
        echo "This file should be provided by your Aurora system image."
        exit 1
    fi
        
    echo "✓ Found Aurora fonts Brewfile: $BREWFILE"
    echo "Installing fonts from Aurora fonts bundle..."
    echo
        
    # Run brew bundle with the Aurora fonts Brewfile
    if brew bundle --file "$BREWFILE"; then
        echo
        echo "✅ Aurora fonts installed successfully!"
        echo "All fonts from the Aurora fonts bundle are now available."
    else
        echo
        echo "✗ Failed to install some fonts from Aurora fonts bundle"
        echo "Check the error messages above for details"
        exit 1
    fi

# Install Homebrew package manager (Linuxbrew for Fedora Kinoite)
install-homebrew:
    #!/usr/bin/env bash
    echo "Installing Homebrew (Linuxbrew) on Fedora Kinoite..."
    
    # Check if Homebrew is already installed
    if command -v brew >/dev/null 2>&1; then
        echo "✓ Homebrew is already installed"
        brew --version
        exit 0
    fi
    
    echo "Downloading and running Homebrew installation script..."
    echo "This may take a few minutes and will require your password..."
    
    # Run the official Homebrew installation script
    if /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; then
        echo "✓ Homebrew installation completed successfully!"
        
        # On Linux, Homebrew installs to /home/linuxbrew/.linuxbrew
        BREW_PATH="/home/linuxbrew/.linuxbrew/bin"
        
        # Add Homebrew to PATH for the current session
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
        
        echo
        echo "📝 Important: Add Homebrew to your shell profile"
        echo "Add the following line to your ~/.bashrc:"
        echo "eval \"\$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)\""
        echo
        echo "Or run this command to add it automatically:"
        echo "echo 'eval \"\$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)\"' >> ~/.bashrc"
        echo
        echo "Then restart your terminal or run: source ~/.bashrc"
        
        # Verify installation
        if command -v brew >/dev/null 2>&1; then
            echo
            echo "✅ Homebrew is ready to use on Fedora Kinoite!"
            brew --version
        fi
    else
        echo "✗ Homebrew installation failed"
        echo "Please check the error messages above and try again"
        exit 1
    fi

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

# Add current user to developer groups (docker, incus-admin, libvirt, dialout)
add-user-to-dx-group:
    #!/usr/bin/env bash
    echo "Adding current user to developer groups..."
    
    # Define the groups to add
    GROUPS=("docker" "incus-admin" "libvirt" "dialout")
    
    # Get current username
    CURRENT_USER=$(whoami)
    
    echo "User: $CURRENT_USER"
    echo
    
    # Create groups if they don't exist and add user to them
    for group in "${GROUPS[@]}"; do
        # Check if group exists, create if it doesn't
        if ! getent group "$group" >/dev/null 2>&1; then
            echo "Creating group: $group"
            sudo groupadd "$group"
        else
            echo "✓ Group '$group' already exists"
        fi
        
        # Check if user is already in the group
        if id -nG "$CURRENT_USER" | grep -qw "$group"; then
            echo "✓ User '$CURRENT_USER' is already in group '$group'"
        else
            echo "Adding user '$CURRENT_USER' to group '$group'"
            sudo usermod -aG "$group" "$CURRENT_USER"
            echo "✓ Successfully added user to group '$group'"
        fi
        echo
    done
    
    echo "✅ User group configuration complete!"
    echo
    echo "📝 Important: You need to log out and log back in for group changes to take effect."
    echo "   Or run: newgrp docker (and repeat for each group)"

# Prepare system for Nix installation (requires reboot)
nix-prep:
    #!/usr/bin/env bash
    echo "Preparing system for Nix installation..."
    echo "This will configure composefs and transient root, then reboot."
    echo
    
    # Create the prepare-root.conf
    sudo tee /etc/ostree/prepare-root.conf > /dev/null <<'EOL'
    [composefs]
    enabled = yes
    [root]
    transient = true
    EOL
    
    echo "✓ Created /etc/ostree/prepare-root.conf"
    echo
    echo "⚠️  System will now configure initramfs and REBOOT"
    echo "After reboot, run: ujust install-nix"
    echo
    
    # Track the config and reboot
    rpm-ostree initramfs-etc --reboot --track=/etc/ostree/prepare-root.conf

# Install Nix package manager with ostree support
install-nix:
    #!/usr/bin/env bash
    echo "Installing Nix with ostree support..."
    
    # Check if Nix is already installed
    if command -v nix >/dev/null 2>&1; then
        echo "✓ Nix is already installed"
        nix --version
        exit 0
    fi
    
    echo "Downloading and running Determinate Nix installer..."
    echo "This may take a few minutes..."
    echo
    
    # Install Nix with ostree support
    if curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | \
        sh -s -- install ostree --no-confirm --persistence=/var/lib/nix; then
        echo
        echo "✓ Nix installation completed successfully!"
        
        # Source Nix for current session
        if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
            . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
        fi
        
        echo
        echo "Adding nixpkgs unstable channel..."
        if nix-channel --add https://nixos.org/channels/nixpkgs-unstable nixpkgs && \
           nix-channel --update; then
            echo "✓ Added nixpkgs unstable channel"
        else
            echo "✗ Failed to add nixpkgs unstable channel"
            exit 1
        fi
        
        echo
        echo "Installing Home-Manager..."
        if nix-shell '<home-manager>' -A install; then
            echo
            echo "✅ Nix and Home-Manager installed successfully!"
            echo
            echo "📝 Nix is now ready to use!"
            echo "   Try: nix-shell -p hello"
        else
            echo
            echo "✗ Failed to install Home-Manager"
            echo "You can try installing it manually later with:"
            echo "  nix-shell '<home-manager>' -A install"
            exit 1
        fi
    else
        echo
        echo "✗ Nix installation failed"
        echo "Please check the error messages above and try again"
        exit 1
    fi

# Uninstall all Nix packages and remove Nix completely
uninstall-nix:
    #!/usr/bin/env bash
    echo "Uninstalling Nix and all installed packages..."
    echo
    
    # Check if Nix is installed
    if ! command -v nix >/dev/null 2>&1; then
        echo "✓ Nix is not installed"
        exit 0
    fi
    
    echo "Step 1: Removing all packages from nix profile..."
    # List installed packages in the profile
    if nix profile list 2>/dev/null | grep -q '.'; then
        echo "Installed packages:"
        nix profile list
        echo
        echo "Removing all packages from profile..."
        # Get all package indices and remove them
        nix profile list | awk '{print $1}' | tac | while read -r idx; do
            if [[ -n "$idx" ]]; then
                echo "Removing package at index $idx..."
                nix profile remove "$idx" 2>/dev/null || true
            fi
        done
        echo "✓ Profile packages removed"
    else
        echo "✓ No profile packages to remove"
    fi
    echo
    
    echo "Step 2: Running Determinate Nix uninstaller..."
    if /nix/nix-installer uninstall --no-confirm; then
        echo "✓ Nix uninstaller completed successfully"
    else
        echo "✗ Nix uninstaller failed or not found"
        echo "Attempting manual cleanup..."
        
        # Manual cleanup steps
        echo "Stopping Nix services..."
        sudo systemctl stop nix-daemon.socket nix-daemon.service 2>/dev/null || true
        sudo systemctl disable nix-daemon.socket nix-daemon.service 2>/dev/null || true
        
        echo "Removing Nix directories..."
        sudo rm -rf /nix /etc/nix ~/.nix-profile ~/.nix-defexpr ~/.nix-channels 2>/dev/null || true
        sudo rm -rf /var/lib/nix ~/.local/state/nix 2>/dev/null || true
        
        echo "Removing Nix users and group..."
        for i in {1..32}; do
            sudo userdel "nixbld$i" 2>/dev/null || true
        done
        sudo groupdel nixbld 2>/dev/null || true
    fi
    echo
    
    echo "✅ Nix uninstallation complete!"
    echo "📝 You may want to remove Nix-related lines from your shell configuration files."
    echo "   To complete cleanup, run: ujust undo-nix-prep"

# Undo nix-prep configuration and restore system to pre-Nix state (requires reboot)
undo-nix-prep:
    #!/usr/bin/env bash
    echo "Undoing Nix preparation configuration..."
    echo "This will remove transient root and composefs settings, then reboot."
    echo
    
    # Check if the prepare-root.conf exists
    if [ ! -f /etc/ostree/prepare-root.conf ]; then
        echo "✓ /etc/ostree/prepare-root.conf does not exist - nothing to undo"
        exit 0
    fi
    
    echo "Current configuration:"
    cat /etc/ostree/prepare-root.conf
    echo
    
    # Remove the prepare-root.conf
    sudo rm -f /etc/ostree/prepare-root.conf
    echo "✓ Removed /etc/ostree/prepare-root.conf"
    echo
    
    echo "⚠️  System will now reconfigure initramfs and REBOOT"
    echo "After reboot, the system will be restored to pre-Nix state."
    echo
    
    # Untrack the config and reboot
    rpm-ostree initramfs-etc --reboot --untrack=/etc/ostree/prepare-root.conf
