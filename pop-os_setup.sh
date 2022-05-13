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
CODE=1.67.1
HUGO=0.98.0
JBMONO=2.242
JULIA=1.7
JULIA1=1.7.2
NEOVIM=0.7.0
RSTUDIO=2022.06.0-daily-400

# Check if there are any packages to upgrade
echo
echo "Checking for and installing any updates..."
sudo apt update && sudo apt upgrade

# Packages to install {
typeset -a REPO_PKGS=(
"bash-completion"
"biber"
"dconf-editor"
#"evolution-ews"
"ffmpeg"
"gir1.2-gtop-2.0"
"gnome-sushi"
"gnome-tweaks"
"gpick"
"hplip"
"imagemagick"
#"kitty"
"libcairo2-dev"
"libcurl4-openssl-dev"
"libfontconfig1-dev"
"libfribidi-dev"
"libgconf-2-4"
"libgdal-dev"
"libgit2-dev"
"libgmp-dev"
"libgmp3-dev"
"libgsl-dev"
"libharfbuzz-dev"
"libmagick++-dev"
"libmpfr-dev"
"libnlopt-dev"
"libnode-dev"
"libopenblas-dev"
"libpoppler-cpp-dev"
"libsecret-1-dev"
"libssl-dev"
"libxt-dev"
"lm-sensors"
"meld"
"mpv"
#"nvme-cli"
"qt5ct"
"r-base"
"sane"
#"smartmontools"
"synaptic"
"system76-keyboard-configurator"
"texlive-full"
"tree"
#"zsh"
#"zsh-autosuggestions"
#"zsh-syntax-highlighting"
) # }

# Flatpaks to install {
typeset -a FLATPAKS=(
"com.github.tchx84.Flatseal"
"com.google.Chrome"
#"com.logseq.Logseq"
"com.mattjakeman.ExtensionManager"
"com.microsoft.Teams"
#"com.obsproject.Studio"
#"com.play0ad.zeroad"
"com.slack.Slack"
#"com.spotify.Client"
#"io.mpv.Mpv"
#"org.audacityteam.Audacity"
"org.flameshot.Flameshot"
"org.gnome.DejaDup"
#"org.gnome.GTG"
#"org.gnome.meld"
#"org.gnome.World.PikaBackup"
"org.inkscape.Inkscape"
#"org.jamovi.jamovi"
#"org.mozilla.firefox"
#"org.olivevideoeditor.Olive"
"org.zotero.Zotero"
"us.zoom.Zoom"
) # }

# Install repo packages
echo
echo "Installing packages from repository"
sudo apt install ${REPO_PKGS[*]} -y
echo
echo "Installing flatpaks from flathub"
flatpak install flathub ${FLATPAKS[*]} -y

# Refresh font cache to jamovi
#echo "Refresh font cache for jamovi"
#flatpak run --command=fc-cache org.jamovi.jamovi -f -v

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
mkdir -p ~/.local/share/pop-launcher/scripts
mkdir -p ~/.local/share/fonts

# Create various files in home folder
echo "Create some files..."
# Create shutdown script for pop-launcher but make poweroff
# rather than power off a keyword
cat > ~/.local/share/pop-launcher/scripts/session-shutdown.sh <<EOF
#!/bin/sh
#
# name: Power off
# icon: system-shutdown
# description: Power off the system
# keywords: poweroff shutdown

gnome-session-quit --power-off
EOF

chmod +x ~/.local/share/pop-launcher/scripts/session-shutdown.sh

# Create .Rprofile with preferred settings
cat > ~/.Rprofile <<EOF
options(scipen = 999)
options(blogdown.ext = ".Rmd", blogdown.author = "Laura St. Germain")

# ~/.Rprofile of Laura St. Germain

EOF

# Create .Renviron for preferred r library location
cat > ~/.Renviron <<EOF
R_LIBS_USER=~/.r/%v

EOF

# Create basic .gitignore
cat > ~/.gitignore <<EOF
.Rproj.user
.Rhistory
.Rdata
.httr-oauth
.DS_Store

EOF

# Create .gitconfig - fill in name and email later
cat > ~/.gitconfig <<EOF
[credential]
	helper = /usr/share/doc/git/contrib/credential/libsecret/git-credential-libsecret
[user]
	name = Laura St. Germain
	email = stgerml@mcmaster.ca
[pull]
	ff = only

EOF

# Create .bash_aliases
cat > ~/.bash_aliases <<EOF
# ~/.bash_aliases

alias update='sudo apt update && sudo apt upgrade && flatpak update'

EOF

# Download some deb files
echo "Downloading deb files..."
wget -O ~/Downloads/code_${CODE}-amd64.deb \
https://update.code.visualstudio.com/${CODE}/linux-deb-x64/stable/
wget -P ~/Downloads \
https://s3.amazonaws.com/rstudio-ide-build/desktop/jammy/amd64/rstudio-${RSTUDIO}-amd64.deb
wget -P ~/Downloads \
https://github.com/gohugoio/hugo/releases/download/v${HUGO}/hugo_extended_${HUGO}_Linux-64bit.deb
wget -P ~/Downloads \
https://download.jetbrains.com/fonts/JetBrainsMono-${JBMONO}.zip
#wget -P ~/Downloads \
#https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
#wget -P ~/Downloads \
#https://julialang-s3.julialang.org/bin/linux/x64/${JULIA}/julia-${JULIA1}-linux-x86_64.tar.gz
#wget -P ~/Downloads \
#https://github.com/neovim/neovim/releases/download/v${NEOVIM}/nvim-linux64.deb

# Disable these applications from search
echo "NoDisplay=true" | sudo tee -a \
/usr/share/applications/vim.desktop \
/usr/share/applications/debian-uxterm.desktop \
/usr/share/applications/debian-xterm.desktop \
/usr/share/applications/prerex.desktop \
/usr/share/applications/vprerex.desktop \
/usr/share/applications/texdoctk.desktop \
/usr/share/applications/display-im6.q16.desktop > /dev/null

# Change shell to zsh
#echo
#echo "Changing shell to zsh"
#chsh -s $(which zsh)

# Make libsecret for git credentials
cd /usr/share/doc/git/contrib/credential/libsecret && sudo make

# Fix login to be on primary monitor
#sudo cp ~/.config/monitors.xml /var/lib/gdm3/.config/
#sudo chown gdm:gdm /var/lib/gdm3/.config/monitors.xml

# Notes on Julia install
# sudo cp -r julia-X.X.X /opt/
# sudo ln -s /opt/julia-X.X.X/bin/julia /usr/local/bin/julia

echo
echo "Installation completed succesfully."
sleep 2
echo "Exiting..."
sleep 1
exit 0
