#!/bin/bash
while inotifywait -e modify /var/www/secnodeinfo.txt; do
	break 
done
