#! /bin/sh
#echo $1 $2 $3 $4

for x in `find $1 -type f`; do
  y=`echo $x |sed s,$3,$4,g`
  if cmp $x $y >/dev/null; then
    #echo Identical $x $y
    rm -f $y
    ln $x $y
  # else
    #echo Different $x $y
  fi
done
