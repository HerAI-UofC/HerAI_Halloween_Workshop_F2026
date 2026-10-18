#!/bin/bash
trap 'echo "The ghost sighs and fades... The fourth key is: SPECTER" > /home/guest/house/attic/released.txt; exit 0' TERM
while true; do sleep 1; done