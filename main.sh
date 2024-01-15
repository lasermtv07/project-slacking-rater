#!/bin/bash
#
#project slacking rater
#(c) lasermtv07, 2024
#
#This work is free. You can redistribute it and/or modify it under the
#terms of the Do What The Fuck You Want To Public License, Version 2,
#as published by Sam Hocevar. See http://www.wtfpl.net/ for more details.
parse_month () {
	if [[ $1 == "Jan" ]] then return 0; fi
	if [[ $1 == "Feb" ]] then return 1; fi
	if [[ $1 == "Mar" ]] then return 2; fi
	if [[ $1 == "Apr" ]] then return 3; fi
	if [[ $1 == "May" ]] then return 4; fi
	if [[ $1 == "Jun" ]] then return 5; fi
	if [[ $1 == "Jul" ]] then return 6; fi
	if [[ $1 == "Aug" ]] then return 7; fi
	if [[ $1 == "Sep" ]] then return 8; fi
	if [[ $1 == "Oct" ]] then return 09; fi
	if [[ $1 == "Nov" ]] then return 10; fi
	if [[ $1 == "Dec" ]] then return 11; fi
}
YE=390
rate_efficiency () {
	if [[ $1 -le 14 ]] then out="\e[1;32mGood job!\e[0m";
	elif [[ $1 -le 30 ]] then out="\e[1;33mLaazy\e[0m"; 
	elif [[ $1 -le 80 ]] then out="\e[1;34mDo something you FAILURE!\e[0m"; 
	else out="\e[1;31mOff to GULAG!\e[0m"; fi
}
cm=`date +"%d %b" | sed 's/^.* //'`
parse_month $cm
cm=$?
cd=`date "+%d %b" | sed 's/ .*$//'`
c=$(($cm*30+$cd))
declare -A vl
IFS=$'\n'
av=0
avs=0
for x in `ls -ltr --color=never $1 | sed 1d`
do
	#clean up preceding junk
	v=`echo "$x" | sed 's/^[a-z-]* [0-9]* [a-zA-Z]* [a-zA-Z]* [ ]*[0-9]*[ ]*//gmi' | tr -s '[:space:]'`
	#get file name
	n=`echo "$v" | sed 's/^.* .* .* //'`
	#get monts
	m=`echo $v | sed 's/ .*//gmi'`
	#get days
	d=`echo $v | sed 's/^[A-Za-z]* //gmi' | sed 's/ .*$//gmi'`
	parse_month $m
	m=$?
	f=$(($m*30+$d))
	s=$(($c-$f))
	if [[ $s -lt 0 ]]
	then
		s=$(($YE+$s))
	fi
	rate_efficiency $(($s))
	echo -ne $n
	if [[ $2 != "-s" ]] then echo -ne " - $out"; fi
	echo -ne " ($s)"
	echo ""
	av=$(($av+$s))
	avs=$(($avs+1))
done
echo
echo "~~~~~~~~~~~~~~~"
echo -ne "\e[0;31mAverage: \e[0m"
rate_efficiency $(($av/$avs))
if [[ $2 != "-s" ]] then echo -ne $out; fi
echo -ne " ($(($av/$avs)))"
echo

