#!/bin/bash -x

USER=/home/test/work/cruise
CHECKOUT=$USER/checkouts

PROTOCOL=svn
SVN_SERVER=10.99.22.20

DO_SWITCH=0
INDEX=1

if [ "$INDEX" == "1" ] ; then

TOOLCHAIN_INDEX=trunk
UBOOT_INDEX=trunk
UBOOT_SUBINDEX=u-boot-2009.06
UCLINUX_DIST_INDEX=branches/2009R1
LINUX_KERNEL_INDEX=branches/2009R1
#UCLINUX_DIST_INDEX=trunk
#LINUX_KERNEL_INDEX=trunk
TOOLCHAIN_REV=HEAD
UBOOT_REV=HEAD
UCLINUX_DIST_REV=8860
LINUX_KERNEL_REV=7341

elif [ "$INDEX" == "2" ] ; then

TOOLCHAIN_INDEX=branches/toolchain_09r1_branch
UBOOT_INDEX=branches/2009R1
UBOOT_SUBINDEX=u-boot-2008.10
UCLINUX_DIST_INDEX=branches/2009R1
LINUX_KERNEL_INDEX=branches/2009R1
TOOLCHAIN_REV=HEAD
UBOOT_REV=HEAD
UCLINUX_DIST_REV=HEAD
LINUX_KERNEL_REV=HEAD

elif [ "$INDEX" == "3" ] ; then

TOOLCHAIN_INDEX=tags/toolchain_09r1_rc3
UBOOT_INDEX=tags/2009R1-RC3
UBOOT_SUBINDEX=u-boot-2008.10
UCLINUX_DIST_INDEX=tags/2009R1-RC6
LINUX_KERNEL_INDEX=tags/2009R1-RC6
TOOLCHAIN_REV=HEAD
UBOOT_REV=HEAD
UCLINUX_DIST_REV=HEAD
LINUX_KERNEL_REV=HEAD

fi

while [ 1 ] 
do

test_command=`ps aux | grep toolchain_test | grep -v grep | grep -v vi  | head -1 | awk '{print $11}'`

if [ "$test_command" == "" ] ; then

    /home/test/set_tw_recycle.exp
    sleep 3

    if [ "$DO_SWITCH" == "1" ] ; then
    
      cd $CHECKOUT/
      rm -rf toolchain 
      echo -n "Checking out toolchain     " ; date
      svn checkout --username anonymous $PROTOCOL://$SVN_SERVER/toolchain/$TOOLCHAIN_INDEX -r $TOOLCHAIN_REV  toolchain  >/dev/null  2>&1
      find toolchain/gcc* -name "_Pragma3.c" -exec touch {} \;

      rm -rf u-boot
      echo -n "Checking out u-boot     " ; date
      svn checkout --username anonymous $PROTOCOL://$SVN_SERVER/u-boot/$UBOOT_INDEX/$UBOOT_SUBINDEX -r $UBOOT_REV  u-boot >/dev/null  2>&1
    
      rm -rf uclinux-dist
      echo -n "Checking out kernel     " ; date
      svn checkout --ignore-externals  --username anonymous $PROTOCOL://$SVN_SERVER/uclinux-dist/$UCLINUX_DIST_INDEX -r $UCLINUX_DIST_REV  uclinux-dist          >/dev/null  2>&1 
      svn checkout --username anonymous $PROTOCOL://$SVN_SERVER/linux-kernel/$LINUX_KERNEL_INDEX -r $LINUX_KERNEL_REV uclinux-dist/linux-2.6.x                   >/dev/null  2>&1
    
          cd uclinux-dist
    
          for FILE in .svn/dir-props .svn/dir-prop-base
          do
            if [ -e $FILE ] && [ `cat $FILE | grep externals` ] ; then
            chmod 777 $FILE
            ls -l $FILE
            LINES=`cat $FILE | wc -l`
            TAIL=$((LINES - 5 ))
            tail -$TAIL $FILE > tmp
            mv tmp $FILE
            fi
          done

      DO_SWITCH=0
    
    fi
   
    cd $USER/test_scripts/toolchain
    RUN="./toolchain_test  > toolchain_test_log  2>&1"
    (echo $RUN ; ) | sh

fi

sleep 8000

done
