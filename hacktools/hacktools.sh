#!/usr/bin/env bash

echo "   __ __         __  ______          __   "
echo "  / // /__ _____/ /_/_  __/__  ___  / /__ "
echo " / _  / _ \`/ __/  '_// / / _ \/ _ \/ (_-<"
echo "/_//_/\_,_/\__/_/\_\/_/  \___/\___/_/___/ "
echo "                               by 0xsegf  "
                                        
# Download latest release
releases='
projectdiscovery/subfinder projectdiscovery/httpx projectdiscovery/shuffledns projectdiscovery/nuclei projectdiscovery/dnsx
projectdiscovery/naabu lc/gau OWASP/Amass ffuf/ffuf sensepost/gowitness jaeles-project/gospider michenriksen/aquatone
KathanP19/Gxss 
'

# Go Gettables
gotools='
arjunshibu/gcmd hakluke/hakrawler hakluke/hakrevdns tomnomnom/assetfinder tomnomnom/unfurl tomnomnom/gron tomnomnom/httprobe
tomnomnom/waybackurls haccer/subjack eth0izzle/shhgit avineshwar/slurp incogbyte/shosubgo BishopFox/smogcloud
'

# Git clone
clonetools='
OWASP/joomscan securing/DumpsterDiver sa7mon/S3Scanner infosec-au/altdns codingo/Interlace hisxo/gitGraber nsonaniya2010/SubDomainizer
gwen001/github-search SpiderLabs/HostHunter andresriancho/mongo-objectid-predict
'

echo -e 'Downloading releases\n'

for tool in $releases
do
    toolname=$(echo $tool | cut -d'/' -f2)
    mkdir $toolname
    wget -q --show-progress --directory-prefix=$toolname https://github.com$(curl -s $(curl -s https://github.com/$tool/releases/latest | grep 'a href' | cut -d'"' -f2) | grep -iE 'download.*linux.*64' | cut -d'"' -f2)
done

for tool in $gotools
do
    go get -v gitub.com/$tool
done

for tool in $clonetools
do
    git clone https://github.com/$tool
done

# Manual
sudo apt install wfuzz
gem install wpscan
wget -q --show-progress https://github.com$(curl -s $(curl -s https://github.com/danielmiessler/SecLists/releases/latest | grep 'a href' | cut -d'"' -f2) | grep -E 'archive.*tar.gz' | cut -d'"' -f2)

echo -e '\nSetup finished. Install releases by extracting them...'
