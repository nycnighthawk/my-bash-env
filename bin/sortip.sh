#!/bin/bash
/bin/sort -u -n -t . -k 1,1 -k 2,2 -k 3,3 -k 4,4 "$@"
