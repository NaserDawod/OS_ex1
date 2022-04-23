#!/bin/bash
run=$PWD
sub="ano"
if test $# -ge 2
then
    if [[ $3 == "-r" ]]
    then
        cd $1
        for file in $(ls);do
            if [[ "$file" == *"$STRING"*.out ]];then
                rm $1"/"$file
            fi
        done
        for file in $(ls);do
            if [[ "$file" == *.c ]];then
                c=$(grep -i -w -c $2 $file)
                if test $c -ge 1
                then
                    filename="${file%.*}"
                    gcc -w -o $filename.out $file
                fi
            fi
        done
        for file in $(ls)
        do
            if [[ -d $file ]]
            then
                dirPath=$1'/'$file
                temp=$PWD
                cd $run
                $0 $dirPath $2 '-r'
                cd $temp
            fi
        done
    else
        cd $1
        for file in $(ls);do
            if [[ "$file" == *"$STRING"*.out ]];then
                rm $1"/"$file
            fi
        done
        for file in $(ls);do
            if [[ "$file" == *.c ]];then
                c=$(grep -i -w -c $2 $file)
                if test $c -ge 1
                then
                    filename="${file%.*}"
                    gcc -w -o $filename.out $file
                fi
            fi
        done
    fi  
else
    echo Not enough parameters
fi
