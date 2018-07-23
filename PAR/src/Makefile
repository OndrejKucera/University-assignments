# all after symbol '#' is comment

# === which communication library to use ===
CC	=	mpiCC      # for ethernet and infiniband networks

CFLAGS	=
LIBS	=	-lm

default:	generator par-parallel par-sequence

generator:generator.cpp
	$(CC) $(CFLAGS) -o generator generator.cpp $(LIBS)

par-parallel:par-parallel.cpp
	$(CC) $(CFLAGS) -o par-parallel par-parallel.cpp $(LIBS)

par-sequence:par-sequence.cpp
	$(CC) $(CFLAGS) -o par-sequence par-sequence.cpp $(LIBS)

clear:
	rm generator par-parallel par-sequence

removesh:
	rm parallel_job.sh.* serial_job.sh.*

