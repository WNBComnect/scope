DIRLIB=/home/itautec/scope/libs
INC=../../src/Include
DEF=-D_SCOPEDOS -D_SCOPEUNX -D_SCOPELNX
CC=gcc
CFLAGS=-I$(INC) $(DEF)
COMPILE=$(CC) -g $(CFLAGS) -o bin/$@ -L$(DIRLIB) 
EXEC=demo

all: $(EXEC)

$(EXEC): 
	$(COMPILE) ../source/$(EXEC).c -lScopeApi -lScopeCom -lScopeSerial -lm

clean:
	rm $(EXEC)
