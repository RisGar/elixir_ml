UNAME := $(shell uname -s)

ifneq ($(UNAME), Darwin)
$(error Error: OS is not supported)
endif

COMPILE_ARCH := "MacOS (Darwin)"
BLAS := "Apple Accelerate"

ERL_INCLUDE_PATH := $(shell erl -eval 'io:format("~s", [lists:concat([code:root_dir(), "/erts-", erlang:system_info(version), "/include"])])' -s init stop -noshell)
VECLIB_INCLUDE_PATH := /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/System/Library/Frameworks/Accelerate.framework/Frameworks/vecLib.framework/Headers

CFLAGS := -fPIC -O3 -std=c11 -pedantic -Wall -Werror -Wextra -I$(VECLIB_INCLUDE_PATH) -I$(ERL_INCLUDE_PATH) -DACCELERATE_NEW_LAPACK -DACCELERATE_LAPACK_ILP64
LDFLAGS := -lblas -flat_namespace -undefined suppress

SRC_DIRECTORY := ./src
OBJ_DIRECTORY := ./_build/obj
PRIV_DIRECTORY := ./priv

SOURCES := $(shell find $(SRC_DIRECTORY) \( -iname "*.c" ! -iname "*_nifs.c" \) )
OBJECTS := $(SOURCES:$(SRC_DIRECTORY)/%.c=$(OBJ_DIRECTORY)/%.o)
NIFS_SOURCES := $(shell find $(SRC_DIRECTORY) -iname "*_nifs.c" )
NIFS_OBJECTS := $(NIFS_SOURCES:$(SRC_DIRECTORY)/%.c=$(PRIV_DIRECTORY)/%.so)

.PHONY: build
build: $(OBJ_DIRECTORY) $(OBJECTS) $(PRIV_DIRECTORY) $(NIFS_OBJECTS)

$(OBJ_DIRECTORY):
	ERL_CONTENTS := $(shell ls ${ERL_INCLUDE_PATH} )
	@echo $(ERL_CONTENTS)
	@mkdir -p $(OBJ_DIRECTORY)
	@echo 'Compile Arch: '$(COMPILE_ARCH)
	@echo 'Library BLAS: '$(BLAS)

$(OBJECTS): $(OBJ_DIRECTORY)/%.o : $(SRC_DIRECTORY)/%.c $(SRC_DIRECTORY)/%.h
	@echo 'Compiling: '$<
	@$(CC) $(CFLAGS) -c $< -o $@

$(PRIV_DIRECTORY):
	@mkdir -p $(PRIV_DIRECTORY)

$(NIFS_OBJECTS): $(PRIV_DIRECTORY)/%.so : $(SRC_DIRECTORY)/%.c $(OBJECTS)
	@echo 'Creating NIF: '$@
	@$(CC) $(CFLAGS) $(OBJECTS) -o $@ $< $(LDFLAGS)
