#!/usr/bin/env bash

echo "   __ __         __  ______          __   "
echo "  / // /__ _____/ /_/_  __/__  ___  / /__ "
echo " / _  / _ \`/ __/  '_// / / _ \/ _ \/ (_-<"
echo "/_//_/\_,_/\__/_/\_\/_/  \___/\___/_/___/ "
echo "                               by 0xsegf  "

echo -e 'Initial setup\n'
sudo apt update
sudo apt install -y python3 python3-pip python2 golang nodejs npm unzip
curl https://bootstrap.pypa.io/get-pip.py | sudo python2
sudo snap install ruby --classic

# Download latest release
releases='
projectdiscovery/subfinder projectdiscovery/httpx projectdiscovery/shuffledns projectdiscovery/nuclei projectdiscovery/dnsx
projectdiscovery/naabu lc/gau lc/subjs OWASP/Amass ffuf/ffuf sensepost/gowitness michenriksen/aquatone
'

# Go Gettables
gotools='
arjunshibu/gcmd hakluke/hakrawler hakluke/hakrevdns jaeles-project/gospider tomnomnom/unfurl tomnomnom/gron tomnomnom/httprobe
haccer/subjack avineshwar/slurp BishopFox/smogcloud
'

# Git clone
clonetools='
OWASP/joomscan securing/DumpsterDiver sa7mon/S3Scanner codingo/Interlace hisxo/gitGraber nsonaniya2010/SubDomainizer
gwen001/github-search SpiderLabs/HostHunter andresriancho/mongo-objectid-predict devanshbatham/ParamSpider
'

echo -e '\nDownloading releases\n'

for tool in $releases
do
    toolname=$(echo $tool | cut -d'/' -f2)
    wget -q --show-progress --directory-prefix=$toolname https://github.com$(curl -s $(curl -s https://github.com/$tool/releases/latest | grep 'a href' | cut -d'"' -f2) | grep -iE 'download.*linux.*64' | cut -d'"' -f2)
done

echo -e '\nInstalling Go tools\n'

for tool in $gotools
do
    go get -v github.com/$tool
done

echo -e '\nCloning repositories\n'

for tool in $clonetools
do
    git clone https://github.com/$tool
done

echo -e '\nInstalling other tools\n'

# Manual
pip install dnsgen
sudo apt install -y wfuzz jq
sudo npm i -g terser
wget -q --show-progress --directory-prefix=dalfox https://github.com$(curl -s $(curl -s https://github.com/hahwul/dalfox/releases/latest | grep 'a href' | cut -d'"' -f2) | grep -iE 'download.*linux.*amd64.*gz' | cut -d'"' -f2)
wget -q --show-progress https://github.com$(curl -s $(curl -s https://github.com/danielmiessler/SecLists/releases/latest | grep 'a href' | cut -d'"' -f2) | grep -E 'archive.*tar.gz' | cut -d'"' -f2) -O SecLists.tgz

# TODO
# Add docker installation for eth0izzle/shhgit

echo -e '\nSetup finished. Install releases by extracting them...'
