#!/bin/bash
figlet -f smslant subgrab
if [ "$#" != 1 ]
then
    echo Usage: ./subgrab.sh example.com
    exit -1
fi
crtsh() {
    curl -s https://crt.sh/\?q\=$1\&output\=json | jq | awk -F'"' '/value/{print $4}' | sed 's/*.//g;s/\\n/\n/g'
}
alienvault() {
    curl -s https://otx.alienvault.com/api/v1/indicators/domain/$1/passive_dns | jq | awk -F': ' '/"hostname": "(.*'$1')"/{print $2}' | sed 's/[",]//g'
}
bufferover() {
    curl -s https://dns.bufferover.run/dns\?q\=.$1 | awk -F',' '/.*'$1'/{print $2}' | sed 's/"//g'
}
hackertarget() {
    curl -s http://api.hackertarget.com/hostsearch/\?q\=$1 | cut -d',' -f1
}
rapiddns() {
    curl -s https://rapiddns.io/subdomain/$1\?full\=1 | awk -F'">' '/'$1'/{print $2}' | cut -d'<' -f1 | awk 'NF'                    }
sublist3r() {
    curl -s https://api.sublist3r.com/search.php\?domain\=$1 | jq | awk -F'"' '/'$1'/{print $2}'                                    }                                                                 threatcrowd() {
    curl -s https://www.threatcrowd.org/searchApi/v2/domain/report/\?domain\=$1 | jq | awk -F'"' '/\.'$1'/{print $2}' | sed 's/ //g'}                                                                 sources='crtsh alienvault bufferover hackertarget rapiddns sublist3r threatcrowd'
echo "Finding subdomains for $1"
for cmd in $sources                                               do
    res="$res $($cmd $1)"
done
echo $res | sed 's/ /\n/g' | sort -u
