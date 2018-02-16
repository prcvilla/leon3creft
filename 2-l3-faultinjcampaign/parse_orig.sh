#!/bin/bash

_DEBUG="off"

function DEBUG()
{
	[ "$_DEBUG" == "on" ] &&  $@
}

NITERS=$2

DEBUG echo "NITERS:$NITERS"

declare -i OK=0
declare -i NOK=0
declare -i I=0

echo "" > basic-orig-errors

for FILE in $1
do
	I+=1
DEBUG echo -n "$(basename $FILE);"

	ITERS=$(grep iteration\ no $FILE | wc -l)
DEBUG echo -n "$ITERS;"

	PROGFIN=$(grep prog\ fin $FILE | wc -l)
DEBUG echo -n "$PROGFIN;"

	EXECERR=$(grep 'prog exec ERROR' $FILE | wc -l)
DEBUG echo -n "$EXECERR;"

	PROGSTATUS=$(grep progstatus:\  $FILE | awk '{print $2}')
DEBUG echo $PROGSTATUS

	if [[ ( $ITERS == $NITERS) && ( $PROGFIN == 1 ) ]]; then
		OK+=1
	fi
	if [[ ( $ITERS != $NITERS) || ( $PROGFIN != 1 ) || ( $EXECERR == 1 ) ]]; then
		NOK+=1
		echo $(head -n 1 $FILE) >> basic-orig-errors
	fi

DEBUG echo "TOTAL:$I OK:$OK NOK:$NOK"

	if (( $I != ( $OK + $NOK ) )); then
		echo -n $(basename $FILE)
		echo "MISMATCH!!!!!!!"
		break
	fi
#debug
[ "$_DEBUG" == "on" ] && read
done

echo "TOTAL:$I OK:$OK NOK:$NOK"
echo "TOTAL,OK,NOK"
echo "$I,$OK,$NOK"
