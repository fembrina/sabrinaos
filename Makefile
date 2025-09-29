CC = gcc
CFLAGS = -g -Wall -Wextra -Werror -Wfloat-equal -Wstrict-prototypes -std=c23 -pedantic
SRC = $(wildcard *.c)
OBJS = $(SRC:.c=.o)
BIN = main

all: $(BIN)

$(BIN): $(OBJS)
	$(CC) $(CFLAGS) $(OBJS) -o $@

%.o: %.c
	$(CC) $(CFLAGS) -c $<

.PHONY : clean
clean:
	$(RM) $(OBJS) $(BIN)