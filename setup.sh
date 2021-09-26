#!/bin/sh

base_dir="/usr/class/cs143/cool"
for dir in `ls`; do
    echo "$dir"
    if [ -d "$dir" ]; then
        chmod -R 755 "$dir"
        ln -s "$dir" "../$d"
    fi
done
# can't iterate for the following files so create the link one at a time
cd ./bin
ln -s ../lib/.i686/cgen refcgen 
ln -s ../lib/.i686/lexer reflexer 
ln -s ../lib/.i686/parser refparser 
ln -s ../lib/.i686/semant refsemant

ln -s /usr/class/cs143/cool ~/cool






