#!/bin/bash

set -eu

curl \
	--url 'https://raw.githubusercontent.com/hagezi/dns-blocklists/main/hosts/ultimate.txt' \
	--url 'https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn-social-only/hosts' \
	--url 'https://badmojr.github.io/1Hosts/mini/hosts.txt' \
	--url 'https://raw.githubusercontent.com/badmojr/1Hosts/master/Pro/hosts.txt' \
	--url 'https://adaway.org/hosts.txt' \
	--url 'https://raw.githubusercontent.com/jdlingyu/ad-wars/master/hosts' \
	--url 'https://raw.githubusercontent.com/AdroitAdorKhan/EnergizedProtection/master/core/hosts' \
	--url 'https://raw.githubusercontent.com/Yhonay/antipopads/master/hosts' \
	--url 'https://raw.githubusercontent.com/anudeepND/blacklist/master/adservers.txt' \
	--url 'https://raw.githubusercontent.com/bjornstar/hosts/master/hosts' \
	--url 'https://0xacab.org/my_privacy_dns/clefspeare13_pornhosts/-/raw/master/download_here/0.0.0.0/hosts' \
	--url 'https://raw.githubusercontent.com/MetaMask/eth-phishing-detect/master/src/hosts.txt' \
	--url 'https://raw.githubusercontent.com/FadeMind/hosts.extras/master/add.2o7Net/hosts' \
	--url 'https://raw.githubusercontent.com/FadeMind/hosts.extras/master/add.Dead/hosts' \
	--url 'https://raw.githubusercontent.com/FadeMind/hosts.extras/master/add.Risk/hosts' \
	--url 'https://raw.githubusercontent.com/FadeMind/hosts.extras/master/add.Spam/hosts' \
	--url 'https://raw.githubusercontent.com/HexxiumCreations/threat-list/gh-pages/hosts.txt' \
	--url 'https://raw.githubusercontent.com/bigdargon/hostsVN/master/option/hosts-VN' \
	--url 'https://raw.githubusercontent.com/PolishFiltersTeam/KADhosts/master/KADhosts.txt' \
	--url 'https://www.github.developerdan.com/hosts/lists/ads-and-tracking-extended.txt' \
	--url 'https://hblock.molinero.dev/hosts' \
	--url 'https://cdn.jsdelivr.net/gh/neoFelhz/neohosts@gh-pages/basic/hosts.txt' \
	--url 'https://raw.githubusercontent.com/notracking/hosts-blocklists/master/hostnames.txt' \
	--url 'https://pgl.yoyo.org/adservers/serverlist.php?showintro=0;hostformat=hosts' \
	--url 'https://raw.githubusercontent.com/mhxion/pornaway/master/hosts/porn_sites.txt' \
	--url 'https://raw.githubusercontent.com/Sinfonietta/hostfiles/master/pornography-hosts' \
	--url 'https://someonewhocares.org/hosts/hosts' \
	--url 'http://sbc.io/hosts/hosts' \
	--url 'https://raw.githubusercontent.com/StevenBlack/hosts/master/data/StevenBlack/hosts' \
	--url 'https://raw.githubusercontent.com/crazy-max/WindowsSpyBlocker/master/data/hosts/spy.txt' \
	--url 'https://winhelp2002.mvps.org/hosts.txt' \
	--url 'https://raw.githubusercontent.com/yous/YousList/master/hosts.txt' \
	--url 'https://raw.githubusercontent.com/Kartatz/Hosts/refs/heads/master/my-hosts' \
	--fail \
	--silent \
	--doh-url 'https://1.0.0.1/dns-query' \
	--ipv4 \
	--connect-timeout '8' \
	--header 'User-Agent:' \
	--header 'Accept:' \
	| sed -r '/(<|>|\t|#|\}|\)|;)/d; s/\\//g; s/\r//g; s/^127\.0\.0\.1/0.0.0.0/g; s/^0\.0\.0\.0/::/g' \
	| awk 'NF && !seen[$0]++' \
	> 'hosts'

python3.11 -B -u hosts.py

mv './hosts2' './hosts'
