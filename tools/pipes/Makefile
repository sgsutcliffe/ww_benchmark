# the compiler: gcc for C program
CC = gcc

#compiler flags:
# -g adds debugging information to the executable file
#  -Wall turns on most, but not all, compiler warnings
#INC_DIR="$CONDA_PREFIX/include"
#CFLAGS= -w
DBGCFLAGS = -g
#  -lz links the gz library
LIBS = -lz -lpthread
#sources
SOURCES = eliminate_strains.c options.c 
ALIGNMENT = align_reference.c needleman_wunsch.c alignment.c alignment_scoring.c
OBJECTS = (SOURCES: .c = .o)
# the build target executable:
TARGET = eliminate_strains

all: $(TARGET)
$(TARGET): $(TARGET).c
	$(CC) $(CFLAGS) -o $(TARGET) $(SOURCES) $(ALIGNMENT) $(LDFLAGS) $(LIBS)
debug: $(TARGET).c
	$(CC) $(DBGCFLAGS) -o $(TARGET) $(SOURCES) $(ALIGNMENT) $(LIBS)

clean:
	$(RM) $(TARGET)
