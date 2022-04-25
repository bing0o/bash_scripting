#!/bin/bash
#
# Bash script i use to install some hacking tools
#



printf "update and upgrade:\n"
sudo apt update -y
sudo apt upgrade -y


printf "[*] Setup Your SHELL:\n"
printf "[+] Installing ZSH:\n"
sudo apt install -y zsh
sudo apt install -y wget git

printf "[+] Installing OhMyZsh:\n"
export RUNZSH=no
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" 

printf "[+] Installing Syntax-Highlighting:\n"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

printf "[+] Installing ZSH-autosuggestions:\n"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

printf "[+] Installing fzf:\n"
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install

printf "Oh-My-Tmux:"
sudo apt install -y tmux 
cd
git clone https://github.com/gpakosz/.tmux.git
ln -s -f .tmux/.tmux.conf
cp .tmux/.tmux.conf.local .

printf "[+] Done"

printf "\n#####################\n\n"

printf "[*] Setup Your Environment:\n"
printf "[+] Install Golang:\n"

wget https://golang.org/dl/go1.15.2.linux-amd64.tar.gz -O golang.tar.gz 1>/dev/null

read -t 120 -p "Enter Path 'GOROOT': " local
[ -z "$local" ] && local=/usr/local && [ -d "$local" ] || mkdir -p "$local"
tar -C $local -xzf golang.tar.gz 1>/dev/null

mkdir $HOME/bin
mkdir $HOME/tools
export GOROOT=$local/go
export GOPATH=$HOME/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin:$HOME/bin

echo "export GOROOT=$local/go" >> $HOME/.zsh_profile
echo "export GOPATH=$HOME/go" >> $HOME/.zsh_profile
echo 'export PATH=$PATH:$GOROOT/bin:$GOPATH/bin:$HOME/bin' >> $HOME/.zsh_profile
echo 'source $HOME/.zsh_profile' >> $HOME/.zshrc

source $HOME/.zsh_profile

printf "[+] Done"

printf "\n#########################\n\n"


printf "[*] Setup Your Tools:\n"

printf "Make & GCC:\n"
sudo apt install -y make gcc

printf "SubFinder:\n"
GO111MODULE=on go get -u -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder

printf "Amass:\n"
GO111MODULE=on go get -v github.com/OWASP/Amass/v3/...

printf "Nuclei:\n"
GO111MODULE=on go get -u -v github.com/projectdiscovery/nuclei/v2/cmd/nuclei

printf "Nuclei-Templates:\n"
git clone https://github.com/projectdiscovery/nuclei-templates $HOME/tools/nuclei-templates

printf "HTTProbe:\n"
go get -u github.com/tomnomnom/httprobe

printf "Assetfinder:\n"
go get -u github.com/tomnomnom/assetfinder

printf "Gron:\n"
go get -u github.com/tomnomnom/gron

printf "Filter-Resolved:\n"
go get github.com/tomnomnom/hacks/filter-resolved

printf "ANew\n"
go get -u github.com/tomnomnom/anew

printf "Kxss:\n"
go get -u github.com/tomnomnom/hacks/kxss

printf "GF:\n"
go get -u github.com/tomnomnom/gf

printf "UnfURL:\n"
go get -u github.com/tomnomnom/unfurl

printf "FFUF:\n"
go get github.com/ffuf/ffuf

printf "CF-check:\n"
go get -u github.com/dwisiswant0/cf-check

printf "Naabu:\n"
GO111MODULE=on go get -v github.com/projectdiscovery/naabu/cmd/naabu

printf "Gau\n"
GO111MODULE=on go get -u -v github.com/lc/gau
mv "$GOPATH/bin/gau" "$GOPATH/bin/ggau"

printf "Webanalyze:\n"
go get -u github.com/rverton/webanalyze/...

printf "Pencode:\n"
go get -u github.com/ffuf/pencode/cmd/pencode

printf "Wuzz:\n"
go get github.com/asciimoo/wuzz

printf "Shuffledns:\n"
GO111MODULE=on go get -u -v github.com/projectdiscovery/shuffledns/cmd/shuffledns

printf "HTTPx:\n"
GO111MODULE=on go get -u -v github.com/projectdiscovery/httpx/cmd/httpx

printf "GoSpider:\n"
go get -u github.com/jaeles-project/gospider

printf "Go-Dork:\n"
GO111MODULE=on go get -v github.com/dwisiswant0/go-dork/...

printf "Hakrawler:\n"
go get github.com/hakluke/hakrawler

printf "Qsreplace:\n"
go get -u github.com/tomnomnom/qsreplace

printf "SubJS:\n"
GO111MODULE=on go get -u -v github.com/lc/subjs

printf "Bash Scripting:\n"
git clone https://github.com/bing0o/bash_scripting/ $HOME/tools/bash_scripting

printf "Python Scripts:\n"
git clone https://github.com/bing0o/Python-Scripts/ $HOME/tools/Python-Scripts

printf "git-dumper:\n"
git clone https://github.com/arthaud/git-dumper $HOME/tools/git-dumper

printf "Arjun:\n"
git clone https://github.com/s0md3v/Arjun $HOME/tools/Arjun

printf "MassDNS:\n"
apt install -y make
git clone https://github.com/blechschmidt/massdns $HOME/tools/massdns
cd $HOME/tools/massdns && make && cp ./bin/massdns $HOME/bin

printf "Chaospy:\n"
git clone https://github.com/dr-0x0x/chaospy $HOME/tools/chaospy

printf "AEM Hacker:\n"
git clone https://github.com/0ang3el/aem-hacker/ $HOME/tools/aem-hacker

printf "SubEum:\n"
wget https://raw.githubusercontent.com/bing0o/SubEnum/master/subenum.sh -O $HOME/bin/subenum 
chmod +x $HOME/bin/subenum

printf "nmap:\n"
sudo apt install -y nmap

printf "masscan:\n"
sudo apt install -y masscan

printf "JQ:\n"
sudo apt -y install jq
