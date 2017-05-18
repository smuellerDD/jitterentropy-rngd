# Compile Noise Source as user space application

CC=gcc
CFLAGS ?=-Wextra -Wall -pedantic -fPIE -pie -fstack-protector-strong -fwrapv --param ssp-buffer-size=4
LDFLAGS ?=-Wl,-z,relro,-z,now

# Change as necessary
PREFIX := /usr/local

NAME := jitterentropy-rngd
#C_SRCS := $(wildcard *.c)
C_SRCS := jitterentropy-base.c jitterentropy-rngd.c
C_OBJS := ${C_SRCS:.c=.o}
OBJS := $(C_OBJS)

INCLUDE_DIRS :=
LIBRARY_DIRS :=
LIBRARIES := rt

CFLAGS += $(foreach includedir,$(INCLUDE_DIRS),-I$(includedir))
LDFLAGS += $(foreach librarydir,$(LIBRARY_DIRS),-L$(librarydir))
LDFLAGS += $(foreach library,$(LIBRARIES),-l$(library))

.PHONY: all clean distclean

all: $(NAME)

$(NAME): $(OBJS)
#	scan-build --use-analyzer=/usr/bin/clang $(CC) $(OBJS) -o $(NAME) $(LDFLAGS)
	$(CC) $(OBJS) -o $(NAME) $(LDFLAGS)

install:
	install -m 0755 -s $(NAME) $(PREFIX)/sbin/
	install -m 644 $(NAME).1 $(PREFIX)/share/man/man1/
	gzip -9 $(PREFIX)/share/man/man1/$(NAME).1

clean:
	@- $(RM) $(NAME)
	@- $(RM) $(OBJS)

distclean: clean
