<img width="194" height="210" alt="cbcd91ade598d3c94aaf15b264d952db4f590a9a" src="https://github.com/user-attachments/assets/e2f65348-9399-43a4-802f-8bf82e04a55b" />

# myKinoiteNightly &nbsp; [![bluebuild build badge](https://github.com/whelanh/myKinoiteNightly/actions/workflows/build.yml/badge.svg)](https://github.com/whelanh/myKinoiteNightly/actions/workflows/build.yml)
## *The leading edge of Fedora and KDE...with the safe rollback option built into Kinoite.*

<sub>See the [BlueBuild docs](https://blue-build.org/how-to/setup/) for quick setup instructions for setting up your own repository based on this template.</sub>

## 💽 My Custom Image

This repository builds a custom **Fedora Kinoite image based on the nightly rawhide build**:

   
      Image base:    quay.io/fedora-ostree-desktops/kinoite-nightly:rawhide


## ⏭️ Changes

The nightly Kinoite build images use the COPR solopasha git repos for the latest in-development KDE and KDE-gear packages. *See https://tim.siosm.fr/blog/2023/01/20/introducing-kinoite-nightly-beta/ for further details.* A number of Universal Blue packages are included in order to provide some of the features of a UBlue "dx" experience.  See [/recipes/recipe-nvidia.yml](https://github.com/whelanh/myKinoiteNightly/blob/main/recipes/recipe-nvidia.yml) file for details on what I've added.

Some custom ujust 'recipes' are provided to install homebrew, Universal Blue's Aurora brew bundle, and a curated list of flatpaks if desired.  See [/files/system/usr/share/ublue-os/just/60-custom.just](https://github.com/whelanh/myKinoiteNightly/blob/main/files/system/usr/share/ublue-os/just/60-custom.just) for the list of flatpaks. 

For those interested in the Cosmic desktop as an alternative login option, I've also added ryanbex/cosmic-epoch COPR repo and `cosmic-desktop` to the installed package list.

Also, if interested in Nix, I've copied instructions on how to install Nix from https://github.com/DXC-0/Nix-Dotfiles.

### Additional available ujust commands

- `ujust auto-setup-flatpaks` - Automatically install all development Flatpaks on first log in (*This is disabled currently*)
- `ujust install-dev-flatpaks` - Manually install all development Flatpaks
- `ujust remove-dev-flatpaks` - Remove all development Flatpaks (keeps user data)
- `ujust list-dev-flatpaks` - Show installation status of all development Flatpaks
- `ujust install-homebrew` - Install Homebrew (brew)
- `ujust install-aurora-brew-bundle` - Install Universal Blue's Aurora brew bundle
- `ujust install-fonts` - Install additional fonts (from Aurora)
- `ujust add-user-to-dx-group` - Add user to additional dev groups (from Aurora)

### NVIDIA
This image includes a set of packages that should detect your NVIDIA GPU and use the appropriate driver (newer NVIDIA GPUs that can use the nouveau driver).

- `kernel-modules`
- `kernel-modules-extra`
- `linux-firmware`
- `mesa-dri-drivers`
- `xorg-x11-drv-nouveau`
- `libdrm` 

## 🛠️ Installation

> [!WARNING]  
> [This is an experimental feature](https://www.fedoraproject.org/wiki/Changes/OstreeNativeContainerStable), try at your own discretion.

To rebase an existing atomic Fedora installation to the latest build:

- First rebase to the unsigned image, to get the proper signing keys and policies installed:
  ```
  rpm-ostree rebase ostree-unverified-registry:ghcr.io/whelanh/kinoite-nightly-ublue:latest
  ```

- Reboot to complete the rebase:
  ```
  systemctl reboot
  ```
- Then rebase to the signed image, like so:
  ```
  rpm-ostree rebase ostree-image-signed:docker://ghcr.io/whelanh/kinoite-nightly-ublue:latest
  ```

- Reboot again to complete the installation
  ```
  systemctl reboot
  ```

The `latest` tag will automatically point to the latest build. That build will still always use the Fedora version specified in `recipe.yml` (which is the nightly kinoite:rawhide image).

## Nix Install (following copied from https://github.com/DXC-0/Nix-Dotfiles)
**Preparation**
```
sudo tee /etc/ostree/prepare-root.conf <<'EOL'
[composefs]
enabled = yes
[root]
transient = true
EOL

rpm-ostree initramfs-etc --reboot --track=/etc/ostree/prepare-root.conf
```
**Install Nix**
```
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | \
    sh -s -- install ostree --no-confirm --persistence=/var/lib/nix
```
**Add Nix Unstable**
```
nix-channel --add https://nixos.org/channels/nixpkgs-unstable nixpkgs
nix-channel --update
```
**Install Home-Manager**

```nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update

nix-shell '<home-manager>' -A install
```
**Rebuild the configuration**

```
git clone https://github.com/DXC-0/Nix-Dotfiles.git
cd Nix-Dotfiles
mkdir -p $HOME/.config/home-manager
mv * $HOME/.config/home-manager

home-manager switch
```

## ISO

If build on Fedora Atomic, you can generate an offline ISO with the instructions available [here](https://blue-build.org/learn/universal-blue/#fresh-install-from-an-iso). These ISOs cannot unfortunately be distributed on GitHub for free due to large sizes, so for public projects something else has to be used for hosting.

## Verification

These images are signed with [Sigstore](https://www.sigstore.dev/)'s [cosign](https://github.com/sigstore/cosign). You can verify the signature by downloading the `cosign.pub` file from this repo and running the following command:

```bash
cosign verify --key cosign.pub ghcr.io/whelanh/myKinoite-amd:latest
```

## 🙏 Gratitude

I sincerely appreciate all of the hard work by **BlueBuild**, **Fedora**, **Universal Blue** and solopasha for providing COPR KDE Git repos that make this image possible. In particular, I thank **Universal Blue** for their packages available on the COPR repository.
