#!/bin/bash

ifn=$1
size=$2
ofn=$3

# Check input reference

if [[ -z "$ifn" ]]; then
    echo "Error: input file name missing" >&2
    echo "Exiting" >&2; exit 1
else
    if [[ ! -f "$ifn" ]]; then
        echo "Error: input file does not exist" >&2
        echo "Exiting" >&2; exit 1
    else
        echo "Processing reference file:"
        echo -e "\t$ifn"
    fi
fi

bases=`tail -n +2 $ifn | tr '\n' ' ' | sed 's/ //g'`
num_bases="${#bases}"

echo "The reference provided is ${#bases} bp long"

# Check requested number of units

if [[ -z "$size" ]]; then
    echo "Error: number of units missing" >&2
    echo "Exiting" >&2; exit 1
else
    re='^[0-9]+$'
    if [[ ! $size =~ $re ]] ; then
        echo "Error: Provided number of units is not a number" >&2
        echo "Exiting" >&2; exit 1
    fi
fi

if (( $size < 1 )); then
    echo "Error: Provided number of units is outside valid range" >&2
    echo "Exiting" >&2; exit 1
else
    echo "Required number of units (${size}) suitable for the reference"
fi

# Check output location

if [[ -z "$ofn" ]]; then
    echo "Error: Output file name missing" >&2
    echo "Exiting" >&2; exit 1
else
    ofd=`dirname $ofn`
    if [[ ! -d $ofd ]] ; then
        echo "Warning: Output folder does not exist yet" >&2
        echo "Creating output folder:"
        echo -e "\t$ofd"
        mkdir -p $ofd
        if [ $? -ne 0 ] ; then
            echo "Error: Output folder creation failed" >&2
            echo "Exiting" >&2; exit 1
        else
            echo "Output folder successfully created"
        fi
    else
        echo "Output folder already exists"
    fi
fi

# Expand reference

echo "Obtaining looped reference"

expanded=$(printf "${bases}%.0s" $(seq $size))

name=`head -n 1 $ifn`
name_start="`echo $name | cut -d' ' -f1`_${size}_units"
name_out="${name_start} `echo $name | cut -d' ' -f2-`"

echo "Reference expansion complete"

echo "The new reference name will be:"
echo -e "\t$name_out"

echo "Saving new reference at:"
echo -e "\t$ofn"

echo $name_out > $ofn
echo $expanded | fold -w 50 >> $ofn

echo "New reference saved"
echo "Exiting"

exit 0
