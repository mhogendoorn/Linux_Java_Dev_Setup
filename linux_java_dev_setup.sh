echo $'\n'"INSTALL SCRIPT ADDING TOOLS TO UBUNTU MATE 18.10"



#allow using .local domains. Kill and remove the avahi service for that
echo $'\n'"Removing Avahi to be able to use .local domains..."
sudo service avahi-daemon stop
sudo sudo apt-get remove avahi-daemon --yes

echo $'\n'"Updating the system..."
sudo apt-get update
sudo apt-get upgrade --yes

echo $'\n'"Installing Google Chrome browser..."
wget -O ~/Downloads/chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i ~/Downloads/chrome.deb
rm ~/Downloads/chrome.deb

echo $'\n'"Turn on color in mate terminal..."
sed -i '/force_color_prompt=yes/s/^#//g' .bashrc

echo $'\n'"Installing multi-terminal-tool terminator..."
sudo apt-get install --yes terminator 
#create better default settings
mkdir -p ~/.config/terminator
	cat <<EOM | sudo tee -a ~/.config/terminator/config
[global_config]
[keybindings]
[layouts]
  [[default]]
    [[[child1]]]
      parent = window0
      type = Terminal
    [[[window0]]]
      parent = ""
      type = Window
[plugins]
[profiles]
  [[default]]
    background_color = "#3e3d3a"
    cursor_color = "#aaaaaa"
    foreground_color = "#ffffff"
    scrollback_lines = 1000
    show_titlebar = False
EOM
echo "INSTALLED: $(terminator --version)"

echo $'\n'"Installing nemo file browser..."
sudo apt install --yes nemo 
echo "INSTALLED: $(nemo --version)"
read -p "Press enter to continue..."

echo $'\n'"Installing nautilus file browser..."
sudo apt-get install nautilus nautilus-dropbox nautilus-emblems nautilus-extension-brasero nautilus-extension-gnome-terminal nautilus-sendto nautilus-share --yes

echo $'\n'"Installing meld compare..."
sudo apt-get install meld nautilus-compare --yes 
echo "INSTALLED: $(meld --version)"

### make workspace and apps  dirs
echo "Make ~/workspace and ~/apps..."
mkdir -p ~/workspace
mkdir -p ~/apps

#add to bookmarks in Nemo and Nautilus file explorers
echo "file://$HOME/workspace" >> $HOME/.config/gtk-3.0/bookmarks
echo "file://$HOME/apps" >> $HOME/.config/gtk-3.0/bookmarks
read -p "Press enter to continue... "

#add samsung T3 ssd driver
#sudo apt-get install exfat-utils --yes

#touchpad indicator
echo $'\n'"Installing Touchpad Indicator ..."
sudo add-apt-repository ppa:atareao/atareao --yes
sudo apt update
sudo apt install touchpad-indicator --yes
touchpad-indicator &

echo $'\n'"Installing gthumb and gedit..."
sudo apt install gthumb gedit --yes

echo $'\n'"Installing OpenJDK-11 ..."
sudo apt-get install openjdk-11-jdk --yes
sudo apt-get -f install
sed -i '$ a\export IDEA_JDK=/usr/lib/jvm/java-11-openjdk-amd64/' ~/.bashrc
sed -i '$ a\export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64/' ~/.bashrc
echo "INSTALLED: " 
echo "$(/usr/lib/jvm/java-11-openjdk-amd64/bin/java -version)"

echo $'\n'"Installing maven..."
sudo apt install maven --yes
mvn
echo "INSTALLED: $(mvn -version)"


######################################
# SSH and GIT
######################################

echo $'\n'"Generating your SSH key..."
read -p 'What is your email address? : ' YOUR_EMAIL_ADDRESS
read -p 'What is your name? : ' YOUR_NAME
cat /dev/zero | ssh-keygen -t rsa -b 4096 -q -P "" -C "$YOUR_EMAIL_ADDRESS" > /dev/null
echo "--------------------------------------------------------------"
echo "Here is your public SSH-key:"
echo "--------------------------------------------------------------"
cat ~/.ssh/id_rsa.pub
echo " "
read -p "Press enter to continue..."

echo $'\n'"Installing GIT version control ..."
sudo apt install git gitg --yes
git config --global core.eol LF
git config --global core.autocrlf input
git config --global user.name "$YOUR_NAME"
git config --global user.email $YOUR_EMAIL_ADDRESS

#add git branch name to the prompt
sed -i '$ a\#show git stuff!' ~/.bashrc
sed -i '$ a\parse_git_branch() {' ~/.bashrc
sed -i '$ a\    git branch 2> /dev/null | sed -e \x27/^[^*]/d\x27 -e \x27s/* \\(.*\\)/ (\\1)/\x27' ~/.bashrc
sed -i '$ a\}' ~/.bashrc
sed -i '$ a\export PS1="\\u@\\h \\[\\033[32m\\]\\w\\[\\033[33m\\]\\$(parse_git_branch)\\[\\033[00m\\] $ "' ~/.bashrc

#add GitKraken GUI which is free for open source, early-stage startups and non-commercial use
echo $'\n'"Installing GitKraken..."
sudo apt install libgnome-keyring0 --yes
	wget -O ~/Downloads/gitkraken.deb https://release.gitkraken.com/linux/gitkraken-amd64-18.04.deb
	sudo dpkg -i ~/Downloads/gitkraken.deb 
	sudo apt-get install -f --yes 
	rm ~/Downloads/gitkraken.deb
echo $'\n'"INSTALLED: GitKraken"


echo $'\n'"Installing Synaptic package manager..."
sudo apt install synaptic --yes

echo $'\n'"Installing buildnotify to monitor builds... "
sudo apt-get install buildnotify --yes
#add buildnotify to startup apps
mkdir -p ~/.config/autostart
cat <<EOM | tee -a ~/.config/autostart/buildnotify.desktop 
[Desktop Entry]
Type=Application
Exec=buildnotify
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name[en_US]=buildnotify
Name=buildnotify
Comment[en_US]=Buildserver indicator
Comment=Buildserver indicator
EOM
echo $'\n'"Installed: buildnotify to monitor builds."
read -p "Press enter to continue..."

### indicator-multiload system monitor###
echo $'\n'"Installing indicator-multiload to monitor system load... "
sudo apt-get install gnome-system-monitor indicator-multiload --yes
#start indicator-multiload
indicator-multiload &
#add indicator-multiload to startup apps
mkdir -p ~/.config/autostart
cat <<EOM | tee -a ~/.config/autostart/indicator-multiload.desktop 
[Desktop Entry]
Type=Application
Exec=indicator-multiload
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name[en_US]=indicator-multiload
Name=indicator-multiload
Comment[en_US]=Systemload indicator
Comment=Systemload indicator
EOM
echo $'\n'"Installed: indicator-multiload to monitor systemload."

#caffeine indicator
echo $'\n'"Installing caffeine indicator ..."
sudo apt-get install --yes caffeine
caffeine &


### Spring Tool Suite ####
### the latest can be found on https://spring.io/tools
echo $'\n'"Installing Spring Tool Suite ..."
wget -O ~/Downloads/STS.tar.gz http://download.springsource.com/release/STS4/4.0.1.RELEASE/dist/e4.9/spring-tool-suite-4-4.0.1.RELEASE-e4.9.0-linux.gtk.x86_64.tar.gz
mkdir -p ~/apps/
tar xf ~/Downloads/STS.tar.gz -C ~/apps/ 
rm ~/Downloads/STS.tar.gz
# make a .desktop that can be found within menus and pinned to the dock applet
cat <<EOM | tee -a ~/.local/share/applications/sts.desktop
#!/usr/bin/env xdg-open
[Desktop Entry]
Comment=Spring Tool Suite
Terminal=false
Name=STS
Exec=$HOME/apps/sts-4.0.1.RELEASE/SpringToolSuite4
Type=Application
Icon=$HOME/apps/sts-4.0.1.RELEASE/icon.xpm
EOM
chmod a+rwx ~/.local/share/applications/sts.desktop
echo $'\n'"Installed Spring Tool Suite"

### IntelliJ
### the latest can be found on https://www.jetbrains.com/idea/download/
echo $'\n'"Installing IntelliJ..."
wget -O ~/Downloads/intelliJ.tar.gz https://download.jetbrains.com/idea/ideaIC-2018.2.5.tar.gz 
mkdir -p ~/apps/
tar xf ~/Downloads/intelliJ.tar.gz -C ~/apps/ 
rm ~/Downloads/intelliJ.tar.gz
echo $'\n'"Installed IntelliJ"


### Telegram messenger (first install it on your phone!)
echo $'\n'"Installing Telegram ... "
sudo apt install telegram-desktop --yes
# making auto-start
mkdir -p ~/.config/autostart
cat <<EOM | tee -a ~/.config/autostart/indicator-multiload.desktop 
[Desktop Entry]
Type=Application
Exec=/usr/bin/telegram-desktop
Hidden=false
X-MATE-Autostart-enabled=true
Name[en_US]=Telegram
Name=Telegram
Comment[en_US]=
Comment=
EOM

### TEAMVIEWER
echo $'\n'"Installing TeamViewer..."
	wget -O ~/Downloads/teamviewer.deb https://download.teamviewer.com/download/linux/version_14x/teamviewer_amd64.deb 
	sudo dpkg -i ~/Downloads/teamviewer.deb 
	sudo apt-get install -f --yes 
	rm ~/Downloads/teamviewer.deb
echo $'\n'"INSTALLED: $(teamviewer --version)"

### SKYPE
echo $'\n'"Installing Skype..."
wget -O ~/Downloads/skype.deb http://www.skype.com/go/skypeforlinux-64.deb 
sudo dpkg -i ~/Downloads/skype.deb
sudo apt-get install -f --yes 
rm ~/Downloads/skype.deb
echo "INSTALLED: skypeforlinux"

### ALIASES
echo $'\n'"Adding useful commands as alias..."
cat <<EOM | sudo tee -a ~/.bash_aliases
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'
alias l='ls -CF'
alias la='ls -A'
alias ll='ls -alF'
alias ls='ls --color=auto'
alias reloadAliases='source ~/.bash_aliases;echo "$0 finished at $(date)"'
alias switchjava='sudo update-alternatives --config java'
EOM
source ~/.bash_aliases

echo $'\n'"Installing Keepass2 password manager..."
sudo apt install keepass2 --yes

### DropBox
# cd ~/apps && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
# ~/apps/.dropbox-dist/dropboxd
sudo apt install caja-dropbox --yes

### Journaling software RedNotebook ###
sudo add-apt-repository ppa:rednotebook/stable --yes
sudo apt-get update
sudo apt-get install rednotebook --yes

### annptate PDFs ###
sudo apt install okular --yes

### make desktop shortcuts for in plank ###
sudo apt install alacarte --yes

echo $'\n'"Installing Groovy..."
sudo apt-get install unzip zip curl --yes
curl -s get.sdkman.io | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"
echo "INSTALLED: $(sdk version)"
sdk install groovy

#### THEMING ####
sudo apt-get install gtk2-engines-murrine gtk2-engines-pixbuf --yes







