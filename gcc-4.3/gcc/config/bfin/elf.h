#undef  STARTFILE_SPEC
#define STARTFILE_SPEC "\
%{msim:%{!shared:crt0%O%s}} \
%{!msim:%{mcpu=bf561*:%{!msdram:basiccrt561%O%s} %{msdram:basiccrt561s%O%s}; \
		  mcpu=bf60*:%{!msdram:basiccrt60x%O%s} %{msdram:basiccrt60xs%O%s}; \
		     :%{!msdram:basiccrt%O%s} %{msdram:basiccrts%O%s}} \
	%{mcpu=bf561*:%{mmulticore:%{!mcorea:%{!mcoreb:basiccrt561b%O%s}}}} \
	%{mcpu=bf60*:%{mmulticore:%{!mcore0:%{!mcore1:basiccrt60xc1%O%s}}}}} \
crti%O%s crtbegin%O%s crtlibid%O%s"

#undef  ENDFILE_SPEC
#define ENDFILE_SPEC	"crtend%O%s crtn%O%s"

#undef  LIB_SPEC
#define LIB_SPEC "--start-group -lc %{msim:-lsim}%{!msim:-lbfinbsp -lnosys} --end-group \
%{!T*:%{!msim:%{!msdram: \
	      %{mcpu=bf504*:-T bf504.ld%s}%{mcpu=bf506*:-T bf506.ld%s} \
	      %{mcpu=bf512*:-T bf512.ld%s}%{mcpu=bf514*:-T bf514.ld%s} \
	      %{mcpu=bf516*:-T bf516.ld%s}%{mcpu=bf518*:-T bf518.ld%s} \
	      %{mcpu=bf522*:-T bf522.ld%s}%{mcpu=bf523*:-T bf523.ld%s} \
	      %{mcpu=bf524*:-T bf524.ld%s}%{mcpu=bf525*:-T bf525.ld%s} \
	      %{mcpu=bf526*:-T bf526.ld%s}%{mcpu=bf527*:-T bf527.ld%s} \
	      %{mcpu=bf531*:-T bf531.ld%s}%{mcpu=bf532*:-T bf532.ld%s} \
	      %{mcpu=bf533*:-T bf533.ld%s}%{mcpu=bf534*:-T bf534.ld%s} \
	      %{mcpu=bf536*:-T bf536.ld%s}%{mcpu=bf537*:-T bf537.ld%s} \
	      %{mcpu=bf538*:-T bf538.ld%s}%{mcpu=bf539*:-T bf539.ld%s} \
	      %{mcpu=bf542*:-T bf542.ld%s}%{mcpu=bf544*:-T bf544.ld%s} \
	      %{mcpu=bf547*:-T bf547.ld%s}%{mcpu=bf548*:-T bf548.ld%s} \
	      %{mcpu=bf549*:-T bf549.ld%s} \
	      %{mcpu=bf561*:%{!mmulticore:-T bf561.ld%s} \
			    %{mmulticore:%{mcorea:-T bf561a.ld%s}} \
			    %{mmulticore:%{mcoreb:-T bf561b.ld%s}} \
			    %{mmulticore:%{!mcorea:%{!mcoreb:-T bf561m.ld%s}}}} \
	      %{mcpu=bf592*:-T bf592.ld%s} \
	      %{mcpu=bf606*:%{!mmulticore:-T bf606.ld%s} \
			    %{mmulticore:%{mcore0:-T bf606c0.ld%s}} \
			    %{mmulticore:%{mcore1:-T bf606c1.ld%s}} \
			    %{mmulticore:%{!mcore0:%{!mcore1:-T bf606m.ld%s}}}} \
	      %{mcpu=bf607*:%{!mmulticore:-T bf607.ld%s} \
			    %{mmulticore:%{mcore0:-T bf607c0.ld%s}} \
			    %{mmulticore:%{mcore1:-T bf607c1.ld%s}} \
			    %{mmulticore:%{!mcore0:%{!mcore1:-T bf607m.ld%s}}}} \
	      %{mcpu=bf608*:%{!mmulticore:-T bf608.ld%s} \
			    %{mmulticore:%{mcore0:-T bf608c0.ld%s}} \
			    %{mmulticore:%{mcore1:-T bf608c1.ld%s}} \
			    %{mmulticore:%{!mcore0:%{!mcore1:-T bf608m.ld%s}}}} \
	      %{mcpu=bf609*:%{!mmulticore:-T bf609.ld%s} \
			    %{mmulticore:%{mcore0:-T bf609c0.ld%s}} \
			    %{mmulticore:%{mcore1:-T bf609c1.ld%s}} \
			    %{mmulticore:%{!mcore0:%{!mcore1:-T bf609m.ld%s}}}} \
	      %{!mcpu=*:%eno processor type specified for linking} \
	      %{mcpu=bf561*:%{!mmulticore:-T bfin-common-sc.ld%s} \
			   %{mmulticore:-T bfin-common-mc.ld%s}; \
	        mcpu=bf60*:%{!mmulticore:-T bfin-common-sc.ld%s} \
			     %{mmulticore:-T bfin-common-mc0.ld%s}; \
	        :-T bfin-common-sc.ld%s}}}}"

#undef USER_LABEL_PREFIX
#define USER_LABEL_PREFIX "_"

#ifdef __BFIN_FDPIC__
#define CRT_CALL_STATIC_FUNCTION(SECTION_OP, FUNC)	\
asm (SECTION_OP); \
asm ("P3 = [SP + 20];\n\tcall " USER_LABEL_PREFIX #FUNC ";"); \
asm (TEXT_SECTION_ASM_OP);
#endif

#undef SUBTARGET_DRIVER_SELF_SPECS
#define SUBTARGET_DRIVER_SELF_SPECS \
     "%{mfdpic:-msim} %{mid-shared-library:-msim}"

#define NO_IMPLICIT_EXTERN_C
