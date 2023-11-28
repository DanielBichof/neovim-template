#!/bin/bash
# Author: Daniel Bichof (https://github.com/DanielBichof)
# nov 19, 2023

confDirectory="$HOME/.config/nvim/"
zipFile="filetmp.zip"

export NEWT_COLORS='
window=,red
border=white,red
textbox=white,red
button=black,gray
'

USERDIR="/home/$(awk -F ':' '$3==1000 {print $1}' /etc/passwd)"

function install_dependencies() {
    . $USERDIR/.nvm/nvm.sh
    . $USERDIR/.bashrc
    current_version=$(nvm --version)
    compare_version="0.39.0"


    if $( find /etc/apt/sources.list.d/ -iname "neovim*" -type f -exec false {} + ) ; then
        sudo add-apt-repository ppa:deadsnakes/ppa -y
    fi

    if $( find /etc/apt/sources.list.d/ -iname "neovim*" -type f -exec false {} + ) ; then
        sudo add-apt-repository ppa:neovim-ppa/unstable -y
    fi

    if $( find /etc/apt/sources.list.d/ -iname "neovim*" -type f -exec false {} + ) ; then
        sudo add-apt-repository ppa:jonathonf/vim -y
    fi

    sudo apt update

    if $(dpkg -l software-properties-common | grep -q "software-properties*" );then
        sudo apt install software-properties-common -y
    fi

    if [ ! -f /usr/bin/python3.9  ]; then
        sudo apt install python3.9 -y
    fi

    sudo cd ~/Downloads
    sudo curl https://bootstrap.pypa.io/get-pip.py -o ~/Downloads/get-pip.py
    sudo python3.9 get-pip.py -y
    pip install pynvim

    if [[ $(echo -e "$current_version\n$compare_version" | sort -V | head -n1) == "$compare_version" ]]; then
        sudo apt install nodejs -y
        nvm install --lts
    fi

    sudo apt install vim neovim -y
    sudo apt install ripgrep -y
    sudo apt install fd-find
}


function installPluging() {
    sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
}


function installFontHack(){
    if [ -f "/etc/fonts/conf.d/ttf/Hack-Bold.ttf" ]; then
       echo "Font already installed"
        return 0
    fi

    sudo wget https://github.com/source-foundry/Hack/releases/download/v3.003/Hack-v3.003-ttf.zip -O /usr/local/share/fonts/Hack.zip
    sudo unzip /usr/local/share/fonts/Hack.zip -d /etc/fonts/conf.d/
    fc-cache -f -v
    fc-list | grep -q "Hack"
    return $?
}


function makeDirs(){
    mkdir ~/.config/nvim
    touch "~/.config/nvim/init.vim"
}


function getPayload(){
    echo "Configuring neovim"

    payloadLine=$(awk '/^__PAYLOAD__/ {print NR + 1; exit 0; }' $0)
    tail -n+$payloadLine $0 >$zipFile

    if [ ! -f "$zipFile" ]; then
        echo "Erro ao extrair payload!"
        return -1
    fi
    # extract the payload file
    unzip $zipFile -d $confDirectory
    return 0
}


main() {
    echo -e "Installing dependecies"
    install_dependencies
    installPluging
    read -p "Do you wish to install the \"hack\" font? [y/n] " input
    first_char_lower=$(tr '[:upper:]' '[:lower:]' <<< "${input:0:1}")
    if test "$first_char_lower" == "y"; then
        echo "Installing the \"Hack\" Font"
        installFontHack
    fi
    getPayload

    if whiptail --title "WARNING" --yesno "Restart the terminal to ejective the configuration" 8 78 --defaultno 3>&1 1>&2 2>&3; then
        if whiptail --title "WARNING" --yesno "Close all terminal windows" 8 78; then
            sudo pkill terminal && exit 0
        else
            whiptail --title "INFO" --msgbox "Remember to restart your terminal window\nThat's all folks" 8 80
        fi
    else
        whiptail --title "INFO" --msgbox "Remember to restart your terminal window\nThat's all folks" 8 80
    fi

    return 0
}

main $1
exit $?

#the following payload contains the init.vim file as .zip
__PAYLOAD__
