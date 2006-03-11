C { dg-do run }
C
C PR rtl-optimization/25603
C Check if reload handles REG_INC notes correctly.
      PROGRAM BAR
      IMPLICIT REAL (A-H, O-Z)
      DIMENSION WORK(250)

      XSTART = 201.0

      CALL BAR1(NX,NY,NZ,NT,NTIME,NWINDX,NWINDY,NSINKS,NFILT,
     *XSTART,YSTART,ZSTART,TSTART,DELTAX,DELTAY,DELTAZ,DELTAT,PHI,DL,
     *DX,DY,DZ,WORK,IB,IK,ITY,NCOUNT,NPRINT,NGRAPH,NPSTEP,NGSTEP)
      STOP
      END

      SUBROUTINE BAR2(NX,NY,NZ,NT,NTIME,NWINDX,ISH,NSMT,NFILT,
     * XSTART,YSTART,ZSTART,TSTART,DELTAX,DELTAY,DELTAZ,DELTAT,PHI,DL,
     * DX,DY,DZ,IB,IK,ITY,NCOUNT,NPRINT,NGRAPH,NPSTEP,NGSTEP,LFINAL,
     * C,STEPC,POTT,STEPT,UX,STEPU,VY,STEPV,WZ,PRES,STEPP,Q,DKZM,DKZH,
     * ELEV,ELEVX,ELEVY,Z0,HMIX,STEPH,TAVR,OBUK,USTR,TSTR,VDEP,DEP,
     * ZET,HVAR,UM,VM,UG,VG,TM,DKM,DCDX,DCDY,AN,BN,CN,HELP,HELPA)
      IMPLICIT REAL (A-H, O-Z)

      DIMENSION  C(*),STEPC(*),POTT(*),STEPT(*),UX(*),STEPU(*),
     * VY(*),STEPV(*),WZ(*),PRES(*),STEPP(*),Q(*),DKZM(*),DKZH(*),
     * ELEV(*),ELEVX(*),ELEVY(*),Z0(*),HMIX(*),STEPH(*),TAVR(*),
     * OBUK(*),USTR(*),TSTR(*),VDEP(*), DEP(*),ZET(*),HVAR(*),
     * UM(*),VM(*),UG(*),VG(*),TM(*),DKM(*), DCDX(*),DCDY(*),
     * AN(*),BN(*),CN(*),HELP(*),HELPA(*)
C

      RETURN
      END

      SUBROUTINE BAR1(NX,NY,NZ,NT,NTIME,NWINDX,NWINDY,NSINKS,NFILT,
     *XSTART,YSTART,ZSTART,TSTART,DELTAX,DELTAY,DELTAZ,DELTAT,PHI,DL,
     *DX,DY,DZ,WORK,IB,IK,ITY,NCOUNT,NPRINT,NGRAPH,NPSTEP,NGSTEP)

      IMPLICIT REAL (A-H, O-Z)
      DIMENSION  WORK(*)

      if (XSTART .NE. 201.0) then
	call abort
      endif

      CALL BAR2(NX,NY,NZ,NT,NTIME,NWINDX,NWINDY,NSINKS,NFILT,XSTART,
     * YSTART,ZSTART,TSTART,DELTAX,DELTAY,DELTAZ,DELTAT,PHI,DL,
     * DX,DY,DZ,IB,IK,ITY,NCOUNT,NPRINT,NGRAPH,NPSTEP,NGSTEP,LAST,
     * WORK(LC),WORK(LCSTEP),WORK(LPOT),WORK(LTSTEP),WORK(LUX),
     * WORK(LUSTEP),WORK(LVY),WORK(LVSTEP),WORK(LWZ),WORK(LPI),
     * WORK(LPSTEP),WORK(LQ),WORK(LDKZM),WORK(LDKZH),WORK(LELEV),
     * WORK(LELEVX),WORK(LELEVY),WORK(LZ0),WORK(LHMIX),WORK(LSTEPH),
     * WORK(LTAVR),WORK(LOBUK),WORK(LUSTR),WORK(LTSTR),WORK(LVDEP),
     * WORK(LDEP),WORK(LZET),WORK(LHVAR),WORK(LUM),WORK(LVM),WORK(LUG),
     * WORK(LVG),WORK(LTM),WORK(LKM),WORK(LDCDX),WORK(LDCDY),WORK(LAN),
     * WORK(LBN),WORK(LCN),WORK(LHELP),WORK(LHELPA))

      RETURN
      END
