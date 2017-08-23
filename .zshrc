# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
  export ZSH=/home/jarvis/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="lobot"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git common-aliases gitfast git-extras k zsh-autosuggestions zsh-256color zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"


# =============================================================================
# Custom Commands
# =============================================================================


# MineSoc User-Friendly Commands
alias help-me='cat ~/helpdocs'
alias find-consoles='screen -r'
alias whats-running='ps aux | grep .jar'
alias unlock-consoles='screen -d mcinstances'
alias 'train!'='sl'
alias storage='df -h | egrep "Filesystem|minesoc--vg-root|sdb1"'
#restartmodded(){ sleep "$@"; screen -S mcinstances -p 1 -X stuff $'say Server Rebooting in 20 Seconds...'; sleep 20; screen -S mcinstances -p 1 -X stuff $'stop\rrun-modded\r';}
#alias restart-modded='restartmodded'
#startup-gameadmin='/home/gameadmin/startup-gameadmin.sh'
#{screen -X sessionname mcinstances; screen -S mcinstances -p 0 -X $'htop';
#{screen -X sessionname admin;
#restart-atlu13b='/home/gameadmin/restart-atlu13b.sh'
#alias update-server='cp -f OLD/*.json NEW/ && cp -f OLD/eula.txt NEW/ && cp -f OLD/server.properties NEW/ %% cp -rf OLD/WORLD NEW/WORLD && cp -rf OLD/blueprints/ NEW/blueprints/ && cp -rf OLD/hats/ NEW/hats/ && cp -rf OLD/TCSchematics/ NEW/TCSchematics/ && cp -rf OLD/TIWorldData/ NEW/TIWorldData/'



# Terminal File Management
alias cdup='cd ..'
alias cd~='cd ~'
function cdf() # print the name of the symlinked file, then
               # cd to the directory a symlinked-file is contained in
{ echo      $(readlink $1 | sed -e 's/.*\///') && \
  cd        $(readlink $1 | \
  sed -e "s/$(readlink $1 | sed -e 's/.*\///')//") }   # remove the filename from the symlink
alias ccat='pygmentize -g -O style=colorful,linenos=1' # cat, but with syntax highlighting! requires https://github.com/jingweno/ccat
alias readme='zmore' # more memorable (IMO)
alias l='k -h'    # ls -l, but with colors and human-readable file sizes
alias la='k -ah'  # 'k' requires https://github.com/supercrabtree/k
alias lsa='ls -a' # faster.
function findins() {find . -iname "$1"} # case INSensitive find in current directory
function findsen() {find . -name "$1"}  # case SENsitive find in current directory
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh # This is for fzf, the command-line fuzzy finder
alias close='kill $(ps -ax | grep konsole | grep grep -v | sed -e ''s/ .*//'')' # Closes the terminal, keeps processes (tmux) open.


# Function to be lazy and always just use "vim" even when sudo is required.
function vim()
# Does this file ( $1 ) exist? If so:
{ if [ -f $1 ]; then
  # Is this file a symlink?
  # This is a symlinked file.
    #if [ -h test ]; then; echo symlink; else echo regfile; fi
    if [ -h $1 ]; then
      # I have permission to write to this file:
        if   [ "$(ls -l $(readlink $1) | awk '{print $3}')" = "$(whoami)" ]; then
        # edit "filename"
          vim      $(readlink $1)
      # I don't have permssion to write to this file:
        elif [ "$(ls -l $(readlink $1) | awk '{print $3}')" != "$(whoami)" ]; then
        # edit "filename" with administrative privileges
          sudo vim $(readlink $1)
      # Error catching
        else
      # Where is this function erroring?
          echo "There's something wrong with this function.\nEmenates from symlinked file permission checking"
      # End if statement
        fi
  # This is a regular file
    else
    # I have permission to write to this file:
      if   [ "$(ls -l | grep $1 | awk '{print $3}')" = "$(whoami)" ]; then
      # edit "filename"
        vim      $1
    # I don't have permission to write to this file:
      elif [ "$(ls -l | grep $1 | awk '{print $3}')" != "$(whoami)" ]; then
      # edit "filename" with administrative privileges
        sudo vim $1
    # Error catching
      else
      # Where is this function erroring?
        echo "There's something wrong with this function.\nEmenates from regular file permission checking"
    # End if statement
      fi
  # End if statement
    fi
# This file does not exist.
  elif [ ! -f $1 ]; then
  # This is a directory, symlink or not.
    if [ -d $1 ]; then
      echo "This is a directory, not a file. You have changed directory."
      cd $1
      ls
  # Create the file with filename "filename"
    else
    # If I own this directory:
      if   [ "$(ls -ld | awk '{print $3}')"=="$(whoami)" ]; then
    # create and edit "filename"
        vim      $1
    # If I don't own this directory:
      elif [ "$(ls -ld | awk '{print $3}')"!="$(whoami)" ]; then
      # create and edit "filename" with administrative permissions
        sudo vim $1
    # Error catching
      else
      # Where is this function erroring?
        echo "There's something wrong with this function.\nEmenates from current directory permission file making"
    # End if statement
      fi
  # End if statement
    fi
# Error catching
  else
  # Where is this function erroring?
    echo "There's something wrong with this function.\nEmanates from current directory permission checking"
# End if statement
  fi }


# Network Tools
alias wol='wakeonlan f0:79:59:da:ad:d2'
alias mac='arp -a' # finds mac of an IP on the current network
alias tracert='traceroute' # requires 'traceroute'
alias tracrt='tracert'
alias portscan='nmap -sn 192.168.0.0/24 | egrep "Host is up|Nmap scan report for|latency" --color'
alias wirelessreset='
  ID=`lsusb | grep Marvell | sed -e ''s/Bus \([0-9]\{3\}\) Device \([0-9]\{3\}\).*/\1\/\2/g''`
     #lsusb | grep Marvell | sed -e ''s/Bus \([0-9]\{3\}\)//g''
  sudo ~/Programs/USBReset/usbreset /dev/bus/usb/$ID'


# Storage Capacity Aliases
alias dfhmc='df -h | egrep "Filesystem|minesoc--vg-root|sdb1" | egrep "G|%" --color'
alias dfhsuse='df -h | egrep "tmpfs|boot|var|usr|srv|opt|tmp|snapshots" -v | egrep "G|%" --color'
alias dfhdeb='df -h | egrep"udev|tmpfs" -v | egrep "G|%" --color'


# Programs
alias chromium-custom='~/Programs/Chromium/chromium-latest-linux/latest/chrome --no-sandbox' 
alias update-chromium='~/Programs/Chromium/chromium-latest-linux/update.sh' 
alias filezilla-custom='~/Programs/FileZilla/FileZilla3/bin/filezilla'

# Maintenance
alias shutdownnow='sudo shutdown now'
alias restartme='sudo shutdown -r 0'

alias gzinstall='tar -xzf'
alias bz2install='tar -xjf'
function debinstall()
{ sudo dpkg -i $1 && \
  sudo apt-get -f install && \
  sudo dpkg -i $1}
alias rpminstall='rpm -i'

alias listdebpackages='apt list'
alias listsusepackages='zypper se --installed-only \
  | sed -e ''s/i+ | //'' \
  | sed -e ''s/i  | //'' \
  | sed -e ''s/| package//'' \
  | sed -e ''s/| pattern//'' \
  | sed -e ''s/| product//'''
alias listsuseversions='zypper pa \
  | grep "i+ |" \
  | sed -e ''s/i+ | openSUSE-Tumbleweed-Oss     | //'' \
  | sed -e ''s/i+ | @System                     | //'' \
  | sed -e ''s/i+ | openSUSE-Tumbleweed-Non-Oss | //'' \
  | sed -e ''s/i+ | openSUSE-Tumbleweed-Update  | //'' \
  | sed -e ''s/i+ | SuSE                        | //'' \
  | sed -e ''s/i+ | skype (stable)              | //'' \
  | sed -e ''s/| x86_64//'' \
  | sed -e ''s/| noarch//'' \
  | sed -e ''s/| i586//'' \
  | sed -e ''s/| i686//'' \
  | sed -e ''s/|/ | /'''

alias linuxdebupdate='
  sudo apt update && \
  sudo apt upgrade -y && \
  sudo apt-get autoremove'
alias linuxsuseupdate='
  sudo zypper refresh && \
  sudo zypper refresh-services && \
  sudo zypper update -y && \
  sudo zypper verify'
alias distdeblinuxupdate='
  sudo apt update && \
  sudo apt dist-upgrade -y && \
  sudo apt-get autoremove -y'
alias distsuselinuxupdate='
  sudo zypper refresh && \
  sudo zypper refresh-services && \
  sudo zypper dist-upgrade -y && \
  sudo zypper verify'

alias requiredrestart='
  if [ -f /var/run/reboot-required ]; then
    echo ''Reboot is required''
  else
    echo ''No reboot required''
  fi'


# Aliases that need work
#alias rudoagain='sudo !!'
#alias cdupa='cd .. ; la'
#alias cdd *='cd * ; ls'



# =============================================================================
# Minecraft Servers
# =============================================================================

# -----------------------------------------------------------------------------
# ATLauncher Servers
# -----------------------------------------------------------------------------

alias run-atldnstp='cd ~/ATLauncher/DNSTechpack_78101/ && java -Xmx3584M -Xms3584M -XX:+CMSIncrementalPacing -XX:ParallelGCThreads=2 -XX:+AggressiveOpts -XX:+UseConcMarkSweepGC -XX:+UseParNewGC -jar ~/ATLauncher/DNSTechpack_78101/forge-1.7.10-10.13.4.1614-1.7.10-universal.jar nogui'

alias run-atlrr='cd ~/ATLauncher/ResonantRise_3402/ && java -Xmx3584M -Xms3584M -XX:+CMSIncrementalPacing -XX:ParallelGCThreads=2 -XX:+AggressiveOpts -XX:+UseConcMarkSweepGC -XX:+UseParNewGC -jar ~/ATLauncher/ResonantRise_3402/forge-1.7.10-10.13.4.1614-1.7.10-universal.jar nogui'

alias run-atlu13='cd ~/ATLauncher/Unabridged_1710Release13/ && java -Xmx3584M -Xms3584M -XX:+CMSIncrementalPacing -XX:ParallelGCThreads=2 -XX:+AggressiveOpts -XX:+UseConcMarkSweepGC -XX:+UseParNewGC -jar ~/ATLauncher/Unabridged_1710Release13/forge-1.7.10-10.13.4.1614-1.7.10-universal.jar nogui'

alias run-atlu13a='cd ~/ATLauncher/Unabridged_1710Release13a/ && java -Xmx5G -Xms5G -XX:+CMSIncrementalPacing -XX:ParallelGCThreads=2 -XX:+AggressiveOpts -XX:+UseConcMarkSweepGC -XX:+UseParNewGC -jar ~/ATLauncher/Unabridged_1710Release13a/forge-1.7.10-10.13.4.1614-1.7.10-universal.jar nogui'

alias run-atlu13b='cd ~/ATLauncher/Unabridged_1710Release13b/ && java -Xmx7G -Xms7G -XX:+CMSIncrementalPacing -XX:ParallelGCThreads=2 -XX:+AggressiveOpts -XX:+UseConcMarkSweepGC -XX:+UseParNewGC -jar ~/ATLauncher/Unabridged_1710Release13b/forge-1.7.10-10.13.4.1614-1.7.10-universal.jar nogui'

alias run-mor1='cd ~/ATLauncher/MOR_01/ && java -Xmx4G -Xms4G -XX:+CMSIncrementalPacing -XX:ParallelGCThreads=2 -XX:+AggressiveOpts -XX:+UseConcMarkSweepGC -XX:+UseParNewGC -jar ~/ATLauncher/MOR_01/forge-1.7.10-10.13.4.1614.jar nogui'


# -----------------------------------------------------------------------------
# FTB Servers
# -----------------------------------------------------------------------------

alias run-ftbinf='cd ~/FTB/InfinityEvolved_1-7-10_2-6-0/ && java -Xmx3584M -Xms3584M -XX:+CMSIncrementalPacing -XX:ParallelGCThreads=2 -XX:+AggressiveOpts -XX:+UseConcMarkSweepGC -XX:+UseParNewGC -jar ~/FTB/InfinityEvolved_1-7-10_2-6-0/FTBServer-1.7.10-1614.jar nogui'

alias run-ftbinv='cd ~/FTB/Inventions_1-7-10_1-0-2/ && java -Xmx3584M -Xms3584M -XX:+CMSIncrementalPacing -XX:ParallelGCThreads=2 -XX:+AggressiveOpts -XX:+UseConcMarkSweepGC -XX:+UseParNewGC -jar ~/FTB/Inventions_1-7-10_1-0-2/FTBServer-1.7.10-1614.jar nogui'

alias run-ftbme4='cd ~/FTB/ME4/ && java -Xmx5G -Xms5G -XX:+CMSIncrementalPacing -XX:ParallelGCThreads=2 -XX:+AggressiveOpts -XX:+UseConcMarkSweepGC -XX:+UseParNewGC -jar ~/FTB/ME4/forge-1.7.10-10.13.4.1558-1.7.10-universal.jar nogui'

alias run-ftbregrowth='cd ~/FTB/Regrowth/ && java -Xmx5G -Xms5G -XX:+CMSIncrementalPacing -XX:ParallelGCThreads=2 -XX:+AggressiveOpts -XX:+UseConcMarkSweepGC -XX:+UseParNewGC -jar ~/FTB/Regrowth/forge-1.7.10-10.13.4.1558-1.7.10-universal.jar nogui'

# -----------------------------------------------------------------------------
# Custom Modpack Servers
# -----------------------------------------------------------------------------

alias run-modded='cd ~/Custom/15-16_03/ && java -Xmx5G -Xms5G -XX:+CMSIncrementalPacing -XX:ParallelGCThreads=2 -XX:+AggressiveOpts -XX:+UseConcMarkSweepGC -XX:+UseParNewGC -jar ~/Custom/15-16_03/forge-1.7.10.jar nogui'

alias run-trains01='cd ~/Custom/Trains_01/ && java -Xmx5G -Xms5G -XX:+CMSIncrementalPacing -XX:ParallelGCThreads=2 -XX:+AggressiveOpts -XX:+UseConcMarkSweepGC -XX:+UseParNewGC -jar ~/Custom/Trains_01/forge-1.7.10-10.13.4.1614.jar nogui'

# -----------------------------------------------------------------------------
# Vanilla Servers
# -----------------------------------------------------------------------------

alias run-vanilla-1.8-server='cd ~/vanilla-1.8/ && java -Xmx2G -Xms2G -XX:+CMSIncrementalPacing -XX:ParallelGCThreads=2 -XX:+AggressiveOpts -XX
:+UseConcMarkSweepGC -XX:+UseParNewGC -jar ~/vanilla-1.8/minecraft_server.1.8.8.jar nogui'


# =============================================================================
# Minigames
# =============================================================================

alias run-copsandrobbers45='cd ~/minigames/CopsAndRobbers4-5-HighSecurity/ && java -Xmx 2G -Xms 2G -XX:+CMSIncrementalPacing -XX:ParallelGCThreads=2 -XX:+AggressiveOpts -XX:+UseConcMarkSweepGC -XX:+UsePArNewGC -jar ~/minigames/CopsAndRobbers4-5-HighSecurity/minecraft_server.1.8.8.jar nogui'

alias run-skyblock21='cd ~/minigames/SkyBlock2-1/ && java -Xmx 2G -Xms 2G -XX:+CMSIncrementalPacing -XX:ParallelGCThreads=2 -XX:+AggressiveOpts -XX:+UseConcMarkSweepGC -XX:+UseParNewGC -jar ~/minigames/SkyBlock2-1/minecraft_server.1.8.8.jar nogui'

alias run-skyblock21147='cd ~/minigames/SkyBlock2-1_1-4-7/ && java -Xmx 2G -Xms 2G -XX:+CMSIncrementalPacing -XX:ParallelGCThreads=2 -XX:+AggressiveOpts -XX:+UseConcMarkSweepGC -XX:+UseParNewGC -jar ~/minigames/SkyBlock2-1_1-4-7/minecraft_server.1.4.7.jar nogui'

alias run-strandedraft='cd ~/minigames/StrandedRaft/ && java -Xmx 2G -Xms 2G -XX:+CMSIncrementalPacing -XX:ParallelGCThreads=2 -XX:+AggressiveOpts -XX:+UseConcMarkSweepGC -XX:+UseParNewGC -jar ~/minigames/StrandedRaft/minecraft_server.1.8.8.jar nogui'

alias run-pirateroyale='cd ~/minigames/SuperPirateBattleRoyale/ && java -Xmx2G -Xms2G -XX:+CMSIncrementalPacing -XX:ParallelGCThreads=2 -XX:+AggressiveOpts -XX:+UseConcMarkSweepGC -XX:+UseParNewGC -jar ~/minigames/SuperPirateBattleRoyale/minecraft_server.1.8.8.jar nogui'

alias run-wallslan20='cd ~/minigames/TheWalls2-LAN-20m/ && java -Xmx2G -Xms2G -XX:+CMSIncrementalPacing -XX:ParallelGCThreads=2 -XX:+AggressiveOpts -XX:+UseConcMarkSweepGC -XX:+UseParNewGC -jar ~/minigames/TheWalls2-LAN-20m/minecraft_server.1.8.8.jar nogui'

alias run-wallslan35='cd ~/minigames/TheWalls2-LAN-35m/ && java -Xmx2G -Xms2G -XX:+CMSIncrementalPacing -XX:ParallelGCThreads=2 -XX:+AggressiveOpts -XX:+UseConcMarkSweepGC -XX:+UseParNewGC -jar ~/minigames/TheWalls2-LAN-35m/minecraft_server.1.8.8.jar nogui'

alias run-wallsnorm20='cd ~/minigames/TheWalls2-Normal-20m/ && java -Xmx2G -Xms2G -XX:+CMSIncrementalPacing -XX:ParallelGCThreads=2 -XX:+AggressiveOpts -XX:+UseConcMarkSweepGC -XX:+UseParNewGC -jar ~/minigames/TheWalls2-Normal-20m/minecraft_server.1.8.8.jar nogui'

alias run-wallsnorm35='cd ~/minigames/TheWalls2-Normal-35m/ && java -Xmx2G -Xms2G -XX:+CMSIncrementalPacing -XX:ParallelGCThreads=2 -XX:+AggressiveOpts -XX:+UseConcMarkSweepGC -XX:+UseParNewGC -jar ~/minigames/TheWalls2-Normal-35m/minecraft_server.1.8.8.jar nogui'

alias run-tntol='cd ~/minigames/TNTOlympics/ && java -Xmx2G -Xms2G -XX:+CMSIncrementalPacing -XX:ParallelGCThreads=2 -XX:+AggressiveOpts -XX:+UseConcMarkSweepGC -XX:+UseParNewGC -jar ~/minigames/TNTOlympics/minecraft_server.1.8.8.jar nogui'

alias run-airbattle='cd ~/minigames/AirshipBattleRoyale/ && java -Xmx2G -Xms2G -XX:+CMSIncrementalPacing -XX:ParallelGCThreads=2 -XX:+AggressiveOpts -XX:+UseConcMarkSweepGC -XX:+UseParNewGC -jar ~/minigames/AirshipBattleRoyale/minecraft_server.1.8.8.jar nogui'

alias run-tntol2='cd ~/minigames/TNTOlympics2/ && java -Xmx2G -Xms2G -XX:+CMSIncrementalPacing -XX:ParallelGCThreads=2 -XX:+AggressiveOpts -XX:+UseConcMarkSweepGC -XX:+UseParNewGC -jar ~/minigames/TNTOlympics2/minecraft_server.1.9.2.jar nogui'


# =============================================================================
# Backups
# =============================================================================

alias backup-atlu13a-world='zip -r /media/BackupDrive/ATLauncher/Unabridged_1710_13a/Unabridged_1710_13a_backup_$(date +%Y%m%d%T).zip /home/gameadmin/ATLauncher/Unabridged_1710Release13a/Unabidged/'

alias backup-atlu13a-complete='zip -r /media/BackupDrive/ATLauncher/Unabridged_1710_13a/Unabridged_1710_13a_complete_backup_$(date +%Y%m%d%T).zip /home/gameadmin/ATLauncher/Unabridged_1710Release13a/'

alias backup-atlu13b-yabm='sudo mv -f /home/gameadmin/ATLauncher/backups/ /media/BackupDrive/ATLauncher/YABM2_backups/'
alias backup-atlu13b-ftbu='sudo mv -f /home/gameadmin/ATLauncher/Unabridged_1710Release13b/backups/ /media/BackupDrive/ATLauncher/FTBU_backups/'

alias backup-modded-world='zip -r /media/BackupDrive/Custom/15-16_03/modded_backup_$(date +%Y%m%d%T).zip /home/gameadmin/Custom/15-16_03world/'

alias backup-modded-complete='zip -r /media/BackupDrive/Custom/15-16_03/modded_complete_backup_$(date +%Y%m%d).zip /home/gameadmin/Custom/15-16_03/'

alias backup-vanilla-1.8-world='zip -r /media/BackupDrive/Vanilla/vanilla-1.8/vanilla_world_backup_$(date +%Y%m%d%T).zip /home/gameadmin/Vanilla/vanilla-1.8/world/'

alias backup-vanilla-1.8-complete='zip -r /media/BackupDrive/Vanilla/vanilla-1.8/vanilla_complete_backup_$(date +%Y%m%d%T).zip /home/gameadmin/Vanilla/vanilla-1.8/'

alias backup-pirates-world='zip -r /media/BackupDrive/Minigames/SuperPirateBattleRoyale/pirates_complete_backup_$(date +%Y%m%d%T).zip /home/gameadmin/Minigames/SuperPirateBattleRoyale/'

source /root/.oh-my-zsh/custom/plugins/k/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
