func1:
        LINK 16;
        SP += -12;
func2:
        LINK 0;
        [--sp] = ( r7:4 );
        SP += -12;
func3:
        [--SP] =RETS;
        [--sp] = ( r7:4 );
        SP += -12;
func4:
        LINK 0;
        P2.L = 40; P2.H = -40;
        SP = SP + P2;
        [--sp] = ( r7:4 );
        SP += -12;

