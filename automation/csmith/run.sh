# First parameter is the size limit for the generated file
# 1000 by default
if [ -n "$1" ];
then
    limit="$1"
else
    limit=1000
fi

clang="clang"

echo "Using limit $limit"

while [ 0 -eq 0 ];
do
    while [ 0 -eq 0 ];
    do
        csmith -o main.c --concise --no-jumps --no-paranoid --no-builtins

        # so that the size of the code is a little more meaningful
        clang-format -i --style=LLVM main.c

        if [ `wc -l main.c | cut -d' ' -f1` -lt $limit ];
        then break; fi
    done

    out=`$clang -I /usr/include/csmith-2.3.0 --analyze main.c -Xclang -analyzer-disable-checker -Xclang deadcode 2>&1`

    if [ -n "$out" ];
    then break; fi
done

echo "$out"
