#!/bin/bash
vagrant status | \
awk '
BEGIN{ tog=0; }
/^$/{ tog=!tog; }
/./ { if(tog){print $1} }
' | \
xargs -P20 -I {} vagrant up {}