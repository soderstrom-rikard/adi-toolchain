# Target: BFIN with simulator
TDEPFILES= bfin-tdep.o solib.o solib-null.o
TM_FILE= tm-bfin.h
SIM_OBS = remote-sim.o
SIM = ../sim/bfin/libsim.a
DEPRECATED_TM_FILE=tm-bfin.h
#ENABLE_CFLAGS=-I../../../core
#MT_CFLAGS= happens too too early

### Current no need to talk with remote simulator ###
#SIM_OBS = remote-tgt.o
#SIM = simbfin-1.o libutils.a
#TM_CLIBS=-lstdc++ -ldl
