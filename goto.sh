#!/bin/bash
#FUNCTION: Choose and go to directory from a List ( less than 6 items)
##Envir.Var DIR_GT, pass in var. gt_table_toread 
des_dir=$gt_table_toread 
##var
declare -a des
declare -a dir

## READ des dir FROM file:
count=0             #number of directories
lengthdes=0         #length of des longest item
lengthdir=0         #length of dir longest item
while read des[$count] dir[$count]
do
    if [ $lengthdes -lt ${#des[$count]} ];then
        lengthdes=${#des[$count]}
    fi
    if [ $lengthdir -lt ${#dir[$count]} ];then
        lengthdir=${#dir[$count]}
    fi
    let "count=count+1"
done < $des_dir
 NDIR=$count

## print List
use_char=21  
header=(a s d f g h j k l z x c v b n m y u i o p)
printdes=$((lengthdes)) #format var
printdir=$lengthdir     #format var
i=0
inheader=''
ix=0
while [ "x${des[$i]}" != "x" ]
do
    if [ $ix -eq 0 ]; then  
        echo -ne "\033[1;34m"
        ix=1
    else
        echo -ne "\033[1;35m"
        ix=0
    fi
    echo -n "${header[$i]}. "
    printf "%-${printdes}s %-6s %+${printdir}s \n" ${des[$i]} : ${dir[$i]}
    
    let "i=i+1"
done
echo -ne "\033[0m"
if [ -n "$(dirs)" ]; then
    echo "RECENTLY DIRS:"
    n_historydir=$(dirs -v | wc -l)
    rect_dir=$(dirs -v | /usr/bin/head -n 10)
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
    if [ "$n_historydir" -gt 10 ]; then
        if [ $ix -eq 0 ]; then  
           echo -ne "\033[1;34m"
           ix=1
        else
           echo -ne "\033[1;35m"
           ix=0
        fi
        echo ". MORE HISTORY DIRS"
    fi
    echo -ne "\033[0m"
    #display_stack
fi
# choose and go to dir
echo 
echo -n "Go to: "
ndir=-1
i=-1
read inheader 
if [ -n "$(echo $inheader | /bin/grep -E [0-9]\{1,\})" ]; then
     gt_dir=$(dirs -l +$inheader)
     cd $gt_dir
     echo cd $gt_dir
elif [ "$inheader" == "." ]; then
    . $DIR_GT/history_dirs.sh 
elif [ -n "$(echo ${header[@]} | /bin/grep $inheader)" ]; then
    for j in ${header[@]} # find order of inheader in header
    do
        let "i=i+1"
        if [ $j == $inheader ];then
            ndir=$i
            break
        fi
    done
    if [ $ndir -gt -1 ] && [ $ndir -lt $NDIR ]; then
        echo "cd ${dir[$ndir]}"
        cd ${dir[$ndir]}
    fi
fi 

