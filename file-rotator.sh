#!/bin/bash

function printHelp() {
    echo "Usage: file-rotator.sh -d DIR -l SIZE_LIMIT" >& 2
    echo >& 2
    echo "    DIR -- Directory that will bet trimmed." >& 2
    echo "    LIMIT -- Size limit of DIR, in bytes." >& 2
}

function trimData() {
    DIR=$1
    LIMIT=$2

    echo "dir: $DIR. limit: $LIMIT"

    SIZE=`du -b $DIR | sed 's/\t.*//g'`
    echo "dir size: $SIZE"
    

    if [ "$SIZE" -gt "$LIMIT" ]
    then
        echo "$DIR size $SIZE is greater than limit $LIMIT ."
        echo "Will delete files until size gets under the threashold"

        MIN_TIMESTAMP=`date +%s`
        CUR_FILE=''
        for FILE in `ls $DIR`
        do
            echo $FILE
            TIMESTAMP=`stat --printf=%X "$DIR/$FILE"`
            echo "min: $MIN_TIMESTAMP . timestamp: $TIMESTAMP"
            if [ "$MIN_TIMESTAMP" -gt "$TIMESTAMP" ]
            then
                MIN_TIMESTAMP=$TIMESTAMP
                CUR_FILE=$FILE
            fi
        done
        rm "$DIR/$CUR_FILE"
        trimData $DIR $LIMIT
    else
        echo "$DIR size $SIZE is under the limit $LIMIT ."
    fi
}

while getopts ":d::l:" opt
do
    case $opt in
        d)
            DIR=$OPTARG
            ;;
        l)
            LIMIT=$OPTARG
            ;;
        \?)
            echo "invalid option: $OPTARG" >& 2
            ;;
        :)
            echo "Option -$OPTARG requires an argument." >& 2
    esac
done

if [[ -z "$DIR" || ! -d "$DIR" ]]
then
    printHelp
    exit 1
fi


if [[ -z "$LIMIT" ]]
then
    printHelp
    exit 1
fi

trimData $DIR $LIMIT
