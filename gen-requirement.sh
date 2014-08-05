#!/bin/bash

filename=$2
if [[ -z $2 ]]
then
    filename="requirement.txt"
fi
#version
echo "Get version for: $1";
cmd='grep -oE [0-9]+\.[0-9]+\.[0-9]';
v=`$1 --version 2>&1 | $cmd | head -n1`;

major=`echo $v | cut -d '.' -f1`;
minor=`echo $v | cut -d '.' -f2`;
patch=`echo $v | cut -d '.' -f3`;


echo "# File generated with gen-requirement" > $filename
echo "#Soft : $1" >> $filename
echo "" >> $filename

echo "MyPackage==$major.$minor.$patch" >> $filename;

#shared lib
echo "" >> $filename

libs=`readelf -d $1 | grep NEEDED | cut -d[ -f2 | cut -d] -f1`;
for line in $libs
do
    l=`echo $line | sed 's/\.so\./==/g'`;
    echo "$l" >> $filename
done
