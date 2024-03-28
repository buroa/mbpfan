COMPILER=cc

C = c
OBJ = o
OUTPUT_PATH = bin/
SOURCE_PATH = src/
TESTS_PATH = tests/
TESTS_BIN = bin/mbpfan-tests

BIN = bin/mbpfan
CONF = mbpfan.conf
DEPEND_MODULE = mbpfan.depend.conf

COPT = 
CC ?= cc
OBJFLAG = -o
BINFLAG = -o
INCLUDES =
LIBS = -lm
LIBPATH =
CFLAGS += $(COPT) -g $(INCLUDES) -Wall -Wextra -Wno-unused-function -std=c99 -D_POSIX_C_SOURCE=200809L -D_XOPEN_SOURCE=500
LDFLAGS += $(LIBPATH) -g

OBJS := $(patsubst %.$(C),%.$(OBJ),$(wildcard $(SOURCE_PATH)*.$(C)))
TESTS_OBJS := $(patsubst %.$(C),%.$(OBJ),$(wildcard $(TESTS_PATH)*.$(C)))
TESTS_OBJS += $(filter-out %main.$(OBJ),$(OBJS))

.PHONY: all clean tests uninstall install rebuild

%.$(OBJ):%.$(C)
	mkdir -p bin
	@echo Compiling $(basename $<)...
	$(CC) -c $(CFLAGS) $< $(OBJFLAG)$@

all: $(BIN) $(TESTS_BIN)

$(BIN): $(OBJS)
	@echo Linking...
	$(CC) $(LDFLAGS) $^ $(LIBS) $(BINFLAG) $(BIN)

$(TESTS_BIN): $(TESTS_OBJS)
	@echo Linking...
	$(CC) $(LDFLAGS) $^ $(LIBS) $(BINFLAG) $(TESTS_BIN)

clean:
	rm -rf $(SOURCE_PATH)*.$(OBJ) $(BIN)
	rm -rf $(TESTS_PATH)*.$(OBJ) $(TESTS_BIN)

tests: all
	./bin/mbpfan-tests

uninstall:
	rm /usr/sbin/mbpfan
	rm /etc/mbpfan.conf

install: all
	install -d $(DESTDIR)/usr/sbin
	install -d $(DESTDIR)/etc
	install $(BIN) $(DESTDIR)/usr/sbin
	install -m644 $(CONF) $(DESTDIR)/etc
	@echo ""
	@echo "******************"
	@echo "INSTALL COMPLETED"
	@echo "******************"
	@echo ""
	@echo "A configuration file has been copied (might overwrite existing file) to /etc/mbpfan.conf."
	@echo "See README.md file to have mbpfan automatically started at system boot."
	@echo ""
	@echo "Please run the tests now with the command"
	@echo "   sudo make tests"
	@echo ""
rebuild: clean all
#rebuild is not entirely correct
