#!/bin/bash

# progress bar function
prog() {
    local w=80 p=$1;  shift
    # create a string of spaces, then change them to dots
    printf -v dots "%*s" "$(( $p*$w/100 ))" ""; dots=${dots// /.};
    # print those dots on a fixed-width space plus the percentage etc. 
    printf "\r\e[K|%-*s| %3d %% %s" "$w" "$dots" "$p" "$*"; 
}

x=1
totalx=$(find ./*.dcm | wc -l)
onetenth=$((totalx/10))

truncate -s 0 test.txt
for i in $(find ./*.dcm -printf "%f\n")
do
	dcm_to_html $i 2> /dev/null | html2text 2> /dev/null | grep 'ACQ Echo Time' | cut -d '|' -f5 >> test.txt
    #dcm_to_html $i 2> /dev/null | html2text 2> /dev/null | grep 'ACQ Echo Time' | cut -d '|' -f5
    perc=$((100*x/$onetenth))
    prog "$perc" still working...
    x=$((x + 1))
    if [ $perc -gt 99 ]
    then
        break  # Skip entire rest of loop.
    fi
done ; echo

cat test.txt | sort -g | uniq > EchoTimes.txt
cat EchoTimes.txt

rm test.txt
