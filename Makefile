BLAS = blas
COMPILE_ARCH=darwin

ERL_INCLUDE_PATH = $(shell erl -eval 'io:format("~s", [lists:concat([code:root_dir(), "/erts-", erlang:system_info(version), "/include"])])' -s init stop -noshell)
CFLAGS = -fPIC -I$(ERL_INCLUDE_PATH) -O3 -std=c2x -pedantic -Wall -Wextra -I/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/System/Library/Frameworks/Accelerate.framework/Versions/Current/Frameworks/vecLib.framework/Headers
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

# Target for creating directories for the C object files.
$(OBJECTS_DIRECTORIES):
	@mkdir -p $(OBJECTS_DIRECTORIES)
	@echo 'Compile Arch: '$(COMPILE_ARCH)
	@echo 'Library BLAS: '$(BLAS)

# Target for creating object files from C source files.
# Each object file depends on it's corresponding C source file for compilation.
#
# Example:
#   native/obj/matrix.o
#
# Depends on:
#   native/src/matrix.c
#   native/include/matrix.h
#
# Output:
#   ```
#   Compiling: native/src/matrix.c
#   ```
#
$(OBJECTS): $(OBJ_DIRECTORY)/%.o : $(SRC_DIRECTORY)/%.c $(INCLUDE_DIRECTORY)/%.h
	@echo 'Compiling: '$<
	@$(CC) $(CFLAGS) -c $< -o $@

# Target for creating the `priv` directory for the NIF shared objects.
$(PRIV_DIRECTORY):
	@mkdir -p $(PRIV_DIRECTORY)

# Target for creating the NIF shared objects.
#
# Example:
#   priv/worker_nifs.so
#
# Depends on:
#   priv/
#   native/nifs/matrix_nifs.c
#   native/nifs/helpers/network_state_helper.c
#   _build/obj/matrix.o
#
# Output:
#   ```
#   Creating NIF: priv/worker_nifs.so
#   ```
#
$(NIFS_OBJECTS): $(PRIV_DIRECTORY)/%.so : $(NIFS_DIRECTORY)/%.c $(OBJECTS) $(NIFS_HELPERS)
	@echo 'Creating NIF: '$@
	@$(CC) $(CFLAGS) $(OBJECTS) -o $@ $< $(LDFLAGS)
