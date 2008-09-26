	.text
_cmul:
	R0 = CMUL(R0,R1);
	R0 = CMUL(R0,R1*);
	R2 = CMUL(R0*,R1*);
	R0 = CMUL(R1,R2) (T);
	R3:2 = CMUL(R0,R1);
	(A0,A1) = CMUL(R0,R1);
	(A0,A1) = CMUL(R0,R1*);
	(A0,A1) += CMUL(R0,R1);
	R2 = ((A0,A1)=CMUL(R0,R1));
	R2 = ((A0,A1)+=CMUL(R0,R1));
	R2 = ((A0,A1)+=CMUL(R0,R1)) (T);
	R3:2 = ((A0,A1)+=CMUL(R0,R1));
