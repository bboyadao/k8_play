#!/bin/bash
vagrant status | \
awk '
BEGIN{ tog=0; }
/^$/{ tog=!tog; }
/./ { if(tog){print $1} }
' | \
xargs -P30 -I {} vagrant destroy -f {}