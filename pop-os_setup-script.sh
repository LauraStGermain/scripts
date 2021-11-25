#!/bin/bash
#set -e

# -------------------------------------------------------
# A script to automate personal package installation after a fresh
# Pop!_OS installation
#
# Written by Michael Carter
#
# Some ideas and code adapted from other sources, mainly the ArchLabs
# installer (https://www.archlabslinux.com) and the Arch Wiki
# -------------------------------------------------------

# Versions for deb files
CODE=1.62.3
SLACK=4.21.1
SPOTIFY=1.1.72.439.gc253025e
RSTUDIO=2021.09.1-372
TEAMS=1.4.00.26453
HUGO=0.89.4
JBMONO=2.242

# Check if there are any packages to upgrade
echo
echo "Checking for and installing any updates..."
sudo apt update && sudo apt upgrade

# Packages to install
typeset -a REPO_PKGS=(
"biber"
"dconf-editor"
"evolution-ews"
"ffmpeg"
"gir1.2-gtop-2.0"
"gnome-sushi"
"gnome-tweaks"
"gpick"
#"hplip"
"imagemagick"
"inkscape"
"libcairo2-dev"
"libcurl4-openssl-dev"
"libfontconfig1-dev"
"libgconf-2-4"
"libgdal-dev"
"libgit2-dev"
"libgmp-dev"
"libgmp3-dev"
"libgsl-dev"
"libmagick++-dev"
"libmpfr-dev"
"libnode-dev"
"libopenblas-dev"
"libpoppler-cpp-dev"
"libsecret-1-dev"
"libssl-dev"
"libxt-dev"
"lm-sensors"
"meld"
"mpv"
#"neovim"
"qt5ct"
"r-base"
"synaptic"
"system76-keyboard-configurator"
"texlive-full"
"zsh"
"zsh-autosuggestions"
"zsh-syntax-highlighting"
) # }

# Flatpaks to install
typeset -a FLATPAKS=(
"com.github.tchx84.Flatseal"
"org.jamovi.jamovi"
) # }

# Install repo packages
echo
echo "Installing packages from repository"
sudo apt install ${REPO_PKGS[*]} -y
echo
echo "Installing flatpaks from flathub"
flatpak install flathub ${FLATPAKS[*]} -y

# Refresh font cache to jamovi
echo "Refresh font cache for jamovi"
flatpak run --command=fc-cache org.jamovi.jamovi -f -v

# Setup preferred keyboard shortcuts for workspaces
echo "Change keyboard shortcuts for workspaces"
dconf write \
/org/gnome/desktop/wm/keybindings/switch-to-workspace-1 "['<Super>1']"
dconf write \
/org/gnome/desktop/wm/keybindings/switch-to-workspace-2 "['<Super>2']"
dconf write \
/org/gnome/desktop/wm/keybindings/switch-to-workspace-3 "['<Super>3']"
dconf write \
/org/gnome/desktop/wm/keybindings/switch-to-workspace-4 "['<Super>4']"
dconf write \
/org/gnome/desktop/wm/keybindings/switch-to-workspace-5 "['<Super>5']"
dconf write \
/org/gnome/desktop/wm/keybindings/switch-to-workspace-6 "['<Super>6']"
dconf write \
/org/gnome/desktop/wm/keybindings/switch-to-workspace-7 "['<Super>7']"
dconf write \
/org/gnome/desktop/wm/keybindings/switch-to-workspace-8 "['<Super>8']"
dconf write \
/org/gnome/desktop/wm/keybindings/switch-to-workspace-9 "['<Super>9']"
dconf write \
/org/gnome/desktop/wm/keybindings/move-to-workspace-1  "['<Super><Shift>1']"
dconf write \
/org/gnome/desktop/wm/keybindings/move-to-workspace-2  "['<Super><Shift>2']"
dconf write \
/org/gnome/desktop/wm/keybindings/move-to-workspace-3  "['<Super><Shift>3']"
dconf write \
/org/gnome/desktop/wm/keybindings/move-to-workspace-4  "['<Super><Shift>4']"
dconf write \
/org/gnome/desktop/wm/keybindings/move-to-workspace-5  "['<Super><Shift>5']"
dconf write \
/org/gnome/desktop/wm/keybindings/move-to-workspace-6  "['<Super><Shift>6']"
dconf write \
/org/gnome/desktop/wm/keybindings/move-to-workspace-7  "['<Super><Shift>7']"
dconf write \
/org/gnome/desktop/wm/keybindings/move-to-workspace-8  "['<Super><Shift>8']"
dconf write \
/org/gnome/desktop/wm/keybindings/move-to-workspace-9  "['<Super><Shift>9']"

# Change nautilus preference to show option to create links
echo "Enable option to create links in nautilus"
dconf write \
/org/gnome/nautilus/preferences/show-create-link true

# Change touchpad to be natural scrolling
echo "Enable natural scrolling with touchpad"
dconf write \
/org/gnome/desktop/peripherals/touchpad/natural-scroll true

# Make personal directories
#echo "Create personal directories"
#mkdir -p ~/Documents/admin
#mkdir -p ~/Documents/mcmaster-templates
#mkdir -p ~/Documents/mjc
#mkdir -p ~/Documents/research
#mkdir -p ~/Documents/service
#mkdir -p ~/Documents/teaching
#mkdir -p ~/Documents/websites
mkdir -p ~/Pictures/wallpapers
mkdir -p ~/.local/share/pop-launcher/scripts
mkdir -p ~/.local/share/fonts

# Create various files in home folder
echo "Create some files..."
# Create shutdown script for pop-launcher but make poweroff
# rather than power off the keyword
cat > ~/.local/share/pop-launcher/scripts/session-shutdown.sh <<EOF
#!/bin/sh
#
# name: Power off
# icon: system-shutdown
# description: Shut down the system
# keywords: poweroff shutdown

gnome-session-quit --power-off
EOF

# Create .Rprofile and .Renviron files
cat > ~/.Rprofile <<EOF
options(scipen = 999)
options(blogdown.ext = ".Rmd", blogdown.author = "Laura St. Germain")

# ~/.Rprofile of Laura St. Germain

EOF

cat > ~/.Renviron <<EOF
R_LIBS_USER=~/.r/%v

EOF

cat > ~/.gitignore <<EOF
.Rproj.user
.Rhistory
.Rdata
.httr-oauth
.DS_Store

EOF

# Download some deb files
echo "Downloading deb files..."
wget -O ~/Downloads/code_${CODE}-amd64.deb \
https://update.code.visualstudio.com/${CODE}/linux-deb-x64/stable/
wget -P ~/Downloads \
https://downloads.slack-edge.com/releases/linux/${SLACK}/prod/x64/slack-desktop-${SLACK}-amd64.deb
wget -P ~/Downloads \
http://repository.spotify.com/pool/non-free/s/spotify-client/spotify-client_${SPOTIFY}_amd64.deb
wget -P ~/Downloads \
https://download1.rstudio.org/desktop/bionic/amd64/rstudio-${RSTUDIO}-amd64.deb
wget -P ~/Downloads \
https://packages.microsoft.com/repos/ms-teams/pool/main/t/teams/teams_${TEAMS}_amd64.deb
wget -P ~/Downloads \
https://zoom.us/client/latest/zoom_amd64.deb
wget -P ~/Downloads \
https://github.com/gohugoio/hugo/releases/download/v${HUGO}/hugo_extended_${HUGO}_Linux-64bit.deb
wget -P ~/Downloads \
https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
wget -P ~/Downloads \
https://download.jetbrains.com/fonts/JetBrainsMono-${JBMONO}.zip


# Create symlinks of annoying desktop files
# except vim isn't annoying but we use neovim instead
echo "Create symlinks of various desktop files"
ln -s /usr/share/applications/vim.desktop \
~/.local/share/applications/
ln -s /usr/share/applications/debian-uxterm.desktop \
~/.local/share/applications/
ln -s /usr/share/applications/debian-xterm.desktop \
~/.local/share/applications/
ln -s /usr/share/applications/prerex.desktop \
~/.local/share/applications/
ln -s /usr/share/applications/vprerex.desktop \
~/.local/share/applications/
ln -s /usr/share/applications/texdoctk.desktop \
~/.local/share/applications/
ln -s /usr/share/applications/org.gnome.Evolution.desktop \
~/.local/share/applications/
ln -s /usr/share/applications/evolution-calendar.desktop \
~/.local/share/applications/

# Disable these applications from search
echo "NoDisplay=true" | sudo tee -a \
~/.local/share/applications/vim.desktop \
~/.local/share/applications/debian-uxterm.desktop \
~/.local/share/applications/debian-xterm.desktop \
~/.local/share/applications/prerex.desktop \
~/.local/share/applications/vprerex.desktop \
~/.local/share/applications/texdoctk.desktop \
~/.local/share/applications/org.gnome.Evolution.desktop \
~/.local/share/applications/evolution-calendar.desktop > /dev/null

# Change shell to zsh
#echo
#echo "Changing shell to zsh"
#chsh -s $(which zsh)

# Make libsecret for git credentials
cd /usr/share/doc/git/contrib/credential/libsecret && sudo make

echo
echo "Installation completed succesfully."
sleep 2
echo "Exiting..."
sleep 1
exit 0
