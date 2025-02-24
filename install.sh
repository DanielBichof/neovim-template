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
PK    ��qW͊���  b/    init.vimUT	 |�We�\eux �  �  �Z{w�6��_�UNWҌe���NVci&u�M�;�v�{N�U �`�K���N���^����lOt&S���
d�,.�Ofj����#�y��s��<��I��l�NӅ:�&5K��[�Z�FZm	g�;�Զ�J�e���������,WV��=IU�R�G�Z�?����mS���&����V���ɂܘ����n,0I��B�M�d��_�B慎���T� ֡:	Lp��N��o�Y.�`�A6+iU�c�hI��:U'��{�������s��a�Jơ]���.�|�_��S�K�f�B�s]�[t�Uj�P�2^�md�\@rQ�.����6׭��<�ҜȲ0�r�}��B�~�xuΣ�!�q)O�X�2_�#�*p*�L��5�U��	��\|�F�IE��/S9��𻵾;V"5�L� ZX���V��XkQa�pX�D�;�$�¬Y��tyG�N����U �o��9S�}�i\�86Q4~V��C�:)���L��D������JeB�̝2�L�`wA�[�/�dbJ��wb����X�2�Rd�J�t�`�El��wDV�N� ��i��K;9�,7
9������ l�L\&�&�L+��0��LTTT�����H(.e���-i+��������Y��6��ϠO��A���#���L�o�X�X�T^��]#��*�q6�w�ǫR�j�f��Z	_��+m9	xﶴ�b���%��ؠ���	��*���H\u_�R��NŤz�H\-�Bc�Hk;�9��)��0�	��q��P�c�Ε-�bm�cw&�b�"���1v�A0���t+V]*��zG3��8�xnL���X�j����
�'��#�`(c@�rǍu632�e��N!�e���aָf��ǤU7��`Yf����k��A3D$��)�s%��dX��Y�v�f B�����H+dT���L�n5�M"LYXd�m�k	���ǝ%�j��.���['�C�Q,�_ bV���A���-�(�:S��P����f?��\�f
y᠁�v�P�q�D�q�@�	�*��#��r9�p�w�	�Ʈd��l���m
0�#:Å:���8��M��/4R��YŒ5ZF>���2?�g}:{3qW�T��3�=�+1I)�%P�
\�I�� 	'�<`���� �|+FN��s�=�4�F��Q��� �be��lZȹC�FW\�mˋ ��"�$Cu������N"�\�cl'�3���&K�]�K�~�����j�!��f����An���-݉��f��b��U��D���P��/5���2��Vb�/����wzN03U��J+�z����Yr|�*R���+�����)��N��O\lj��p1g�����j/��忷��~���r�_w���EN����Ջ��7f>���/���w��ɍ����X�ɢZ������/,���/�`��ƪv
��
����WW�A�c�&E!^";��9�ؔ�m�뢹w��Jx@�G5�n�;K��j�n�n�����_$�lnT$�#�4S�*�o�X��y���؉�}��������=$�dʕb��G���tj%\r,�q�p��e��[���{�<ɼDtO��x�VL�E8R�k�ퟞ��ۿ|�տ�� �5 ���<��SE3�	?E�r=Z=�R�
eo¥ΩFͮ�X{�g@0��,Nw %����l����a�(z�T�+Tqt�ڮ^�	������d;ѽA��N���qx,.SԹt�	�3��&OP.A[������H{����4�����{�k�B�	ĵo��L����]�!�0��p���=�qG7�uܓ~`���:�A�ޭ�g������i[J�q�0�k�<���]#.�a��as[&���4�	]�,*�H��sݠ�ix��ש'?ed��Y ���e�I��;����͈xF�#/r��k�63FչT�*yT��ڠ�_jМ����|1s�L}OZYȩZq����t�:��:�^4�yW0�sřE��3$�o�7�#�w"+p�QJ �J�{2u��H�	�G58�;y(|\��P�BFh;�1���_J��^h~Tk�w�P�O/��^���e�n����/&\�O)$L97T�H����r!/h��i@��+aG{H��CQ�B3"\����b��&D��2O�W���R�K�!����1���{g{9*������E����X<汙�x
4�B�FoE��P�{����{"��&����\��@{���t�4�FJ�5jE��R�ȕE4|�6-�:�#������D����)�/(�kk���nvPG<�y�O����ns��&q^��C-�3��7�<��W�@[����T$���v ��p%�u��wA(T�\�b;3PM���}W���ڐ�����xEX<2䩎��n�q�j���a!V��C7Xb@�
m� rĿβ8,&�
Hipg�U��xM�Kh������So���������@&��7/GTL�
aT:�<:�J6	���=kS
j�W)�K^���T���������jw����@��_��e�U�w�"��8�#�Fp��F.��U"��m�;U����	�Zl�j�1S��YYp�_,��j�4����I!��v�5���o����wp�v��������zHx�1e8f���b�u7Ii�jB
�A����gj�asS�e�Mf�Q�E�T�R��}.��U�@�f��dz�p&a��U
4�k��J�zH�:�/�?��8�w��>�y����L3A��&_  87���ͥ��c~\�f��jBm�Q�U��m����?���H��=���Y�����\~�Yfx�{O3�Qm�����b��O3e���Ê��f��!5$/l�?Lw�K��27�UU�A��<lQ�N5�m3���p4}X7�5Y9���;�y�A\F�u��#���tB�Is��屢�.㪓n�#~����&v���[������s����or�GQb���n)��A��uP!����!#T%K����H�t�`�#��ϫ��㤻N�g��
Z����j�RA-��՛Z�F�A�s��
 ��)h��7Ͻl�k�\dB�i�*GThY�^�{��n�ܬ��E}�*�]�V��6�O�BN�3����P����O��2�)&М=���U�};�`��zC��e�\g��-:z�Z�Bㆃ��k(�i�fAՌ,(m� ���jtv�?QE��p�it�{F�㺢�
������k�,��d�����v6C�Z�彤�;*H�}p�j*�y.�E۪r�U�cxȲ����ۂ.�{��+�,�����F̫���9��f[��Q�`՚��l�A�P(�j�f�'��@&�%~)u����g���m�<����MA	��������Au���|Z�n�����VD�1v��B�q��C��-���I�׊���I5�'�����,>bsdbi�k{����u���Q� =ڮ�q��\�����2e�I��˫7?�V:�";5-�#��P:��]ƕ{w��=���-���-�����5�۵ע�&�i�5�ҽ��(6����=�LVf�U\O�����Eˋ��e������?��)��:���ԍ��S1�잀����x��7�I4�>���s���gL����w}Ė��ɱ�]Q��X~�s��i��k9vw_�<���;���:�o�^��kN-������'5�n���j+Ll��mm�S=��`���^�Uz�E�:o�>��2���/}��]�8"��8��b�\�*��O�\�C��gѐ@'V�WFd��e��Y��[�f�8(��X�a������P�B��u�R�q��f�QD�B����-�:�!���XJ�O���|��(h��a�<%ehW�ѻ��M��t��y*c??�_k�$s�$�r҆�Hp�@#���OM�����׿��p+��ǯC�ܟ��h|[?�U���䃏>�f(N\�rn�_S��O���{���/xr�rs�.'0jb�O*�_J�h3c�4U�Mu���i��<�`�M�B��G����Ơ��$>��l30%[�:��y���nP�y=��v����
��~a��+_��'L4��4������F�[��=���A�P=�+e�X�/d��p>E.�҆��D�PK    ��qW͊���  b/           ��    init.vimUT |�Weux �  �  PK      N   �    