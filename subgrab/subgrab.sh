#!/bin/bash

echo '            __                 __ '
echo '  ___ __ __/ /  ___ ________ _/ / '
echo ' (_-</ // / _ \/ _ `/ __/ _ `/ _ \'
echo '/___/\_,_/_.__/\_, /_/  \_,_/_.__/'
echo '    by 0xsegf /___/               '
echo

if [ -z "$1" ]
then
    echo 'Usage: ./subgrab.sh example.com [outfile]'
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
    curl -s https://rapiddns.io/subdomain/$1\?full\=1 | awk -F'">' '/'$1'/{print $2}' | cut -d'<' -f1 | awk 'NF'
}
sublist3r() {
    curl -s https://api.sublist3r.com/search.php\?domain\=$1 | jq | awk -F'"' '/'$1'/{print $2}'
}
threatcrowd() {
    curl -s https://www.threatcrowd.org/searchApi/v2/domain/report/\?domain\=$1 | jq | awk -F'"' '/\.'$1'/{print $2}' | sed 's/ //g'
}
subdomainfinder() {
    curl -s https://subdomainfinder.c99.nl/scans/2020-00-00/$1 | grep -hoiE "[0-9]+[09]+[0-9]+[0-9]\-[0-9]+[0-9]\-[0-9]+[0-9]" | sort -u | while read history;do curl -s https://subdomainfinder.c99.nl/scans/$history/$1 | grep -hoiE "((.\-|.\.|.\_)[a-zA-Z0-9._-]|[a-zA-Z0-9._-])+\.$1";done | grep -v "\*"
}

sources='crtsh alienvault bufferover hackertarget rapiddns sublist3r threatcrowd subdomainfinder'

echo "Finding subdomains for $1"

for cmd in $sources
do
    res="$res $($cmd $1)"
done

res=$(echo $res | sed 's/ /\n/g' | sort -u)

[ -z "$2" ] && echo $res | sed 's/ /\n/g' || echo $res | sed 's/ /\n/g' | tee $2
