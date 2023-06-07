BLAS = blas
COMPILE_ARCH=darwin

ERL_INCLUDE_PATH = $(shell erl -eval 'io:format("~s", [lists:concat([code:root_dir(), "/erts-", erlang:system_info(version), "/include"])])' -s init stop -noshell)
VECLIB_INCLUDE_PATH = /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/System/Library/Frameworks/Accelerate.framework/Versions/Current/Frameworks/vecLib.framework/Headers
CFLAGS = -fPIC -O3 -std=c2x -pedantic -Wall -Werror -Wextra -I${VECLIB_INCLUDE_PATH} -I$(ERL_INCLUDE_PATH)
LDFLAGS = -lblas -flat_namespace -undefined suppress

SRC_DIRECTORY = ./native/src
INCLUDE_DIRECTORY = ./native/include
OBJ_DIRECTORY = ./_build/obj
NIFS_DIRECTORY = ./native/nifs
PRIV_DIRECTORY = ./priv

SOURCES_DIRECTORIES := $(shell find $(SRC_DIRECTORY) -type d)
OBJECTS_DIRECTORIES := $(subst $(SRC_DIRECTORY),$(OBJ_DIRECTORY),$(SOURCES_DIRECTORIES))

SOURCES := $(shell find $(SRC_DIRECTORY) -name *.c)
HEADERS := $(shell find $(INCLUDE_DIRECTORY) -name *.h)
OBJECTS := $(SOURCES:$(SRC_DIRECTORY)/%.c=$(OBJ_DIRECTORY)/%.o)
NIFS_SOURCES := $(wildcard $(NIFS_DIRECTORY)/*.c)
NIFS_HELPERS := $(shell find $(NIFS_DIRECTORY) -name *_helper.c)
NIFS_OBJECTS := $(NIFS_SOURCES:$(NIFS_DIRECTORY)/%.c=$(PRIV_DIRECTORY)/%.so)

.PHONY: build
build: $(OBJECTS_DIRECTORIES) $(OBJECTS) $(PRIV_DIRECTORY) $(NIFS_OBJECTS)

$(OBJECTS_DIRECTORIES):
	@mkdir -p $(OBJECTS_DIRECTORIES)
	@echo 'Compile Arch: '$(COMPILE_ARCH)
	@echo 'Library BLAS: '$(BLAS)

$(OBJECTS): $(OBJ_DIRECTORY)/%.o : $(SRC_DIRECTORY)/%.c $(INCLUDE_DIRECTORY)/%.h
	@echo 'Compiling: '$<
	@$(CC) $(CFLAGS) -c $< -o $@

$(PRIV_DIRECTORY):
	@mkdir -p $(PRIV_DIRECTORY)

$(NIFS_OBJECTS): $(PRIV_DIRECTORY)/%.so : $(NIFS_DIRECTORY)/%.c $(OBJECTS) $(NIFS_HELPERS)
	@echo 'Creating NIF: '$@
	@$(CC) $(CFLAGS) $(OBJECTS) -o $@ $< $(LDFLAGS)
