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
ln -s "$base_dir/lib/.i686/cgen" "$base_dir/bin/refcgen" 
ln -s "$base_dir/lib/.i686/lexer" "$base_dir/bin/reflexer" 
ln -s "$base_dir/lib/.i686/parser" "$base_dir/bin/refparser" 
ln -s "$base_dir/lib/.i686/semant" "$base_dir/bin/refsemant" 

ln -s /usr/class/cs143/cool ~/cool






