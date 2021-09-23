!#/bin/sh

dir="/usr/class/cs143/cool"
for d in `ls $dir`; do
    echo "$d"
    if [ -d "$dir" ]; then
        chmod -R 755 "$d"
        ln -s "/usr/class/cs143/cool/$d" "$d"
    fi
done





