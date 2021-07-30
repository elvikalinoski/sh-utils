#!/bin/sh
die () {
    echo >&2 "$@"
    exit 1
}

[ "$#" -eq 4 ] || die "4 argument required, $# provided" 
echo $1 | grep -E -q '^[0-9]+$' || die "Numeric argument required, $# provided"