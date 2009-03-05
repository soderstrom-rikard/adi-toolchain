#!/bin/sh
ret=0
echo 'int main(){return 0;}' > sfx.c
if ${CC:-gcc} ${CFLAGS} ${LDFLAGS} sfx.c ; then
	if [ -e a.out -o -e sfx ] ; then
		:
	elif [ -e a.exe -o -e sfx.exe -o -e a_out.exe ] ; then
		echo ".exe"
	else
		ret=1
	fi
else
	ret=1
fi
rm -f sfx.c a.out a.exe sfx
exit $ret
