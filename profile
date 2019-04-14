#!/usr/bin/env bash

# get rid of the shell flags defined in make/config.mk
shift 3

START=$(date +%s)

/usr/bin/env bash -c "$@"
RESULT=$?

printf "%ds : %s\n" $(expr $(date +%s) - ${START}) "$@" > $$.log

exit ${RESULT}
