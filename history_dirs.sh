#!/bin/bash
##list history dirs (cd to) and select one to cd

echo "HISTORY DIRS:"
rect_dir=$(dirs -v )
n_historydir=$(dirs -v | wc -l)
let "max=n_historydir-1"
ix=0
while [ -n "$rect_dir" ]; do
    print_dir=$(echo $rect_dir | cut -d ' ' -f 1-2)
    if [ $ix -eq 0 ]; then  
       echo -ne "\033[1;34m"
       ix=1
    else
       echo -ne "\033[1;35m"
       ix=0
    fi
    echo $print_dir
    rect_dir=$(echo $rect_dir | cut -d ' ' -f 3-)
done
echo -ne "\033[0m"
# choose and go to dir
echo 
echo -n "Go to (0-$max): "
ndir=-1
i=-1
read inheader 
if [ -n "$(echo $inheader | /bin/grep -E [0-9]\{1,\})" ] &&\
   [ "$inheader" -ge "0" ] && [ "$inheader" -le $max ] ; then
     gt_dir=$(dirs -l +$inheader)
     cd $gt_dir
     echo cd $gt_dir
elif [  "$inheader" != "q" ]; then
    echo -e "\033[1;31m Fail number input"
    echo -ne "\033[0m"
fi 

