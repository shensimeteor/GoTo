#!/bin/bash
## env vars : DIR_GT, GT_TABLE_ONLOAD(set default in bashrc_gt, changed by this)

function gt_help(){
    cat <<EOF
 <Usage>:
 1> gt: GoTo, by default or onload table (by gt load <table>)
 2> gt <table>: GoTo, by <table>
 3> gt -load <table>: load <table> so gt ALWAYS GoTo by <table> afterwards 
 4> gt -reset: reset to default table
 5> gt -new <table>: new table, named as <table>
 6> gt -addwd: add working dir to default or onload table
 7> gt -edit: edit default or onload table
 8> gt -cdtable: cd directory of Tables
 9> gt -h/-help: help
 Tips: <Tab> is helpful when typing commands / tables
EOF
}

function gt_addwd() {
    local des_wd
    local dir_wd
    local nitem
    read -p "Input your description for working dir:" des_wd
    dir_wd=$(pwd)
    if [ "$(gt_checktablefull)" -eq "0" ]; then
        echo "$des_wd   $dir_wd" >> $GT_TABLE_ONLOAD
    else
        echo "\033[1;31m Fail gt addwd: Table: $GT_TABLE_ONLOAD is full\033[0m"
    fi
}

## return 1 full; 0 available
function gt_checktablefull() { 
    local nitem
    local max_elements
    nitem=$( cat $GT_TABLE_ONLOAD | wc -l)
    max_elements=21
    test "$nitem" -ge "$max_elements"  && echo 1 || echo 0
}

function gt_edit(){
    vim $GT_TABLE_ONLOAD
}



n_opt=$#
opts=$@
if [ "$n_opt" -eq "0" ]; then
   #goto
   gt_table_toread=$GT_TABLE_ONLOAD
   . $DIR_GT/goto.sh
fi
if [ "$n_opt" -eq "1" ]; then
    if [ "$opts" == "-addwd" ]; then
    #1. -addwd
        gt_addwd
    elif [ "$opts" == "-edit" ]; then
    #2. -edit
        gt_edit
    elif [ "$opts" == "-reset" ]; then
    #3. -reset
        gt_table=$DIR_GT/Tables/default.tbl
        test -e $gt_table && export GT_TABLE_ONLOAD=$gt_table ||\
        echo -e "\033[1;31m Fail default.tbl not exist\033[0m"
    elif [ "$opts" == "-h" -o "$opts" == "-help" ]; then
    #4. -h/-help
        gt_help
    elif [ "$opts" == "-cdtable" ]; then
    #5. -cdtable
        cd $DIR_GT/Tables/
    else
    ## gt , read table specified
        gt_table_toread=$DIR_GT/Tables/$opts
        test -e $gt_table_toread && . $DIR_GT/goto.sh ||\
        echo -e "\033[1;31m Fail Table $opts not exist\033[0m"
    fi
fi
if [ "$n_opt" -eq "2" ]; then
    if [ "$1" == "-load" ]; then
        gt_table=$DIR_GT/Tables/$2
        test -e $gt_table && export GT_TABLE_ONLOAD=$gt_table ||\
        echo -e "\033[1;31m Fail Table $2 not exist\033[0m"
    elif [ "$1" == "-new" ]; then
        gt_table=$DIR_GT/Tables/$2
        test -e $gt_table && \
        echo -e "\033[1;31m Fail Table $2 already exists\033[0m" || \
        touch $gt_table
    else
        echo -e "\033[1;31m Fail gt command error, please gt -h for help\033[0m"
    fi
fi



