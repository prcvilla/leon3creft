#!/bin/bash

_DEBUG="on"

function DEBUG()
{
	[ "$_DEBUG" == "on" ] &&  $@
}

NITERS=$2

DEBUG echo "NITERS:$NITERS"

declare -i DETECTED=0
declare -i RECOVERED=0
declare -i NOTRECOVERED=0
declare -i RECOVERR=0
declare -i NDETOK=0
declare -i NDETNOK=0
declare -i I=0

for FILE in $1
do
	I+=1
DEBUG echo -n "$(basename $FILE);"

	ITERS=$(grep iteration\ no $FILE | wc -l)
DEBUG echo -n "$ITERS;"

	ERRDET=$(grep Error\ detected $FILE | wc -l)
DEBUG echo -n "$ERRDET;"

	PROGFIN=$(grep prog\ fin $FILE | wc -l)
DEBUG echo -n "$PROGFIN;"

	EXECERR=$(grep 'prog\ exec ERROR' $FILE | wc -l)
DEBUG echo -n "$EXECERR;"

	PROGSTATUS=$(grep progstatus:\  $FILE | awk '{print $2}')
DEBUG echo $PROGSTATUS

	if [ $ERRDET -gt 0 ]; then
		DETECTED+=1

		if [[ ( $PROGFIN == 1 ) ]]; then
			if [[ ( $ITERS == $NITERS) ]]; then
				RECOVERED+=1
			else
				RECOVERR+=1
			fi
		else
			NOTRECOVERED+=1
		fi

	else
		if [[ ( $ITERS == $NITERS) && ( $PROGFIN == 1 ) ]]; then
			NDETOK+=1
		fi

		if [[ ( $PROGFIN == 0 ) ]]; then
			NDETNOK+=1
		fi
	fi

DEBUG echo "TOTAL:$I NDETOK:$NDETOK NDETNOK:$NDETNOK DET:$DETECTED (REC:$RECOVERED NREC:$NOTRECOVERED RECERR:$RECOVERR)"

	if (( $DETECTED != ( $RECOVERED + $NOTRECOVERED + $RECOVERR ) )); then
		echo -n $(basename $FILE)
		echo "DETECTED MISMATCH!!!!!!!!!"
		break
	fi

	if (( $I != ( $DETECTED + $NDETOK + $NDETNOK ) )); then
		echo -n $(basename $FILE)
		echo "NOT DETECTED MISMATCH!!!!!!!"
		break
	fi
#debug
[ "$_DEBUG" == "on" ] && read
done

echo "TOTAL:$I NDETOK:$NDETOK NDETNOK:$NDETNOK DET:$DETECTED (REC:$RECOVERED NREC:$NOTRECOVERED RECERR:$RECOVERR)"
echo "TOTAL,NDETOK,NDETNOK,DET,REC,NREC,RECERR"
echo "$I,$NDETOK,$NDETNOK,$DETECTED,$RECOVERED,$NOTRECOVERED,$RECOVERR"
