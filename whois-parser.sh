#!/bin/bash

# 1
wget -qO root.zone http://www.internic.net/domain/root.zone

# 2
cat root.zone | grep "IN\sNS" | awk '{print $1}' | uniq | sort | sed -r 's/\.//g' | sed '/^$/d' > zone.list 2> /dev/null

# Generating whois.iana.db.php
echo "<?php" > whois.iana.db.php
echo "\$ianawhois = Array (" >> whois.iana.db.php

for zn in `cat zone.list`; do
	whois -h whois.iana.org $zn > zone.tmp
	echo "	\"$zn\" => \"`cat zone.tmp | grep "whois:\s" | awk '{print $2}'`\"," >> whois.iana.db.php
	sleep 1
	# Keep it above 3 seconds to avoid permanent ban
done

echo ");" >> whois.iana.db.php

# Yaiks
rm -f zone.tmp
rm -f root.zone
rm -f zone.list
