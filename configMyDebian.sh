#!/bin/bash

startMain() {
    atualizacoes
    addSudoUser

    #chamar as outras funções aqui...

}

atualizacoes() {
    echo "Fazendo atualizacoes..."
    sudo apt-get update
    sudo apt-get upgrade

    clear
}

addSudoUser() {
    
    # mudar para o metodo de acesso ao arquivo

    echo "Adicionando usuário sudo..."
    echo -e "Qual usuário deve ser adicionado? : "
    read inputName

    userNameDebian = $inputName
    sudo usermod -a -G sudo $userNameDebian

    clear
}

installDevThings() {
    echo "Instalando pacotes para desenvolvimento"

    devThings=()
    
    sudo apt-get install -y curl #para add repositorios mais facilmente
    sudo apt-get install -y git
    sudo apt-get install -y nodejs npm
    sudo apt-get install -y default-jdk
    sudo apt-get install -y default-jre
    
    clear
}

installApps() {    
    echo "Instalando pacotes em .deb..."
    
    #TODO google chrome estão em falta ainda...
    appsFromRepository=("gnome-console" "gnome-shell-pomodoro" "obs-studio" "pinhole")
    
    # -y autoriza sozinho
    for appsFromRepository in "${appsFromRepository[@]}"
    do
      sudo apt-get install -y appsFromRepository  
    done
    
    installSpotify
    installVsCode
    installInstellijIdeaCommunity

    clear
}


removenApps() {
    
    echo "Removendo alguns apps que eu nao uso..."

    appsUnsed=("cheese" "evolution" "zutty" "shotwell" "rhythmbox" "gnome-contacts" "gnome-maps" "vlc" "gnome-terminal")

    for appsUnsed in "${appsUnsed[@]}"
    do
        sudo apt remove -y $appsUnsed
    done

    clear

    echo "Removendo jogos..."

    # completar a lista de pacotes
    jogos=("quadrapassel" "gnome-2048" "gnome-mines" "gnome-sudoku" "fire-in-a-row" "iagno" " ")
 
    for jogos in "${jogos[@]}"
    do
        sudo apt remove -y $jogos
    done

    clear
}

installSpotify() {
    # Instala o spotify .deb
    sudo curl -sS https://download.spotify.com/debian/pubkey_7A3A762FAFD4A51F.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
    echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
    sudo apt-get update
    sudo apt-get install  -y spotify-client
}

installVsCode() {
    curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
    sudo install -o root -g root -m 644 microsoft.gpg /usr/share/keyrings/microsoft-archive-keyring.gpg
    sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/usr/share/keyrings/microsoft-archive-keyring.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
    sudo apt-get update
    sudo apt-get install code
}

installInstellijIdeaCommunity() {
    # Instala o IntelliJ community
    curl -s https://s3.eu-central-1.amazonaws.com/jetbrains-ppa/0xA6E8698A.pub.asc | gpg --dearmor | sudo tee /usr/share/keyrings/jetbrains-ppa-archive-keyring.gpg > /dev/null
    echo "deb [signed-by=/usr/share/keyrings/jetbrains-ppa-archive-keyring.gpg] http://jetbrains-ppa.s3-website.eu-central-1.amazonaws.com any main" | sudo tee /etc/apt/sources.list.d/jetbrains-ppa.list > /dev/null
    sudo apt update
    sudo apt install  -y intellij-idea-community

    clear
}


installFlatpak() {
    echo "Instalando o suporte a flatpak..."

    sudo apt install flatpak
    apt install gnome-software-plugin-flatpak
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

    clear
}

installFlatpakPrograms() {
    echo "Instalando flatpaks..."

    #Inserir mais apps:
    appsFlatpak=("flathub io.github.flattool.Warehouse" "flathub io.github.shiftey.Desktop" "flathub com.getpostman.Postman" )

    for appsFlatpak in "${appsFlatpak[@]}"
    do
        flatpak install -y $appsFlatpak
    done

    clear
}


startMain
sudo reboot