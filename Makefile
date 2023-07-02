SHELL=/opt/homebrew/bin/fish

UNAME := $(shell uname -s)

ifneq ($(UNAME), Darwin)
$(error Error: OS is not supported)
endif

COMPILE_ARCH := "MacOS (Darwin)"
BLAS := "Apple Accelerate"

ERL_INCLUDE_PATH := $(shell erl -eval 'io:format("~s", [lists:concat([code:root_dir(), "/erts-", erlang:system_info(version), "/include"])])' -s init stop -noshell)
VECLIB_INCLUDE_PATH := /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/System/Library/Frameworks/Accelerate.framework/Frameworks/vecLib.framework/Headers

SRC_DIRECTORY := ./nifs/src
INCLUDE_DIRECTORY := ./nifs/include
OBJ_DIRECTORY := ./_build/obj
PRIV_DIRECTORY := ./priv

CFLAGS := -fPIC -O3 -std=c11 -pedantic -Wall -Werror -Wextra -Wno-nullability-extension -mmacosx-version-min=14.0 -I$(VECLIB_INCLUDE_PATH) -I$(ERL_INCLUDE_PATH) -I$(INCLUDE_DIRECTORY) -DACCELERATE_NEW_LAPACK
LDFLAGS := -lblas -flat_namespace -undefined suppress

SOURCES := $(shell find $(SRC_DIRECTORY) \( -iname "*.c" ! -iname "*_nifs.c" \) )
OBJECTS := $(SOURCES:$(SRC_DIRECTORY)/%.c=$(OBJ_DIRECTORY)/%.o)
NIFS_SOURCES := $(shell find $(SRC_DIRECTORY) -iname "*_nifs.c" )
NIFS_OBJECTS := $(NIFS_SOURCES:$(SRC_DIRECTORY)/%.c=$(PRIV_DIRECTORY)/%.so)

.PHONY: build clean
build: $(OBJ_DIRECTORY) $(PRIV_DIRECTORY) $(OBJECTS) $(NIFS_OBJECTS)

$(OBJ_DIRECTORY):
	@mkdir -p $(OBJ_DIRECTORY)
	@echo 'Compile Arch: '$(COMPILE_ARCH)
	@echo 'Library BLAS: '$(BLAS)

$(PRIV_DIRECTORY):
	@mkdir -p $(PRIV_DIRECTORY)

$(OBJECTS): $(OBJ_DIRECTORY)/%.o : $(SRC_DIRECTORY)/%.c $(INCLUDE_DIRECTORY)/%.h
	@echo 'Compiling: '$<
	@$(CC) $(CFLAGS) -c $< -o $@


$(NIFS_OBJECTS): $(PRIV_DIRECTORY)/%.so : $(SRC_DIRECTORY)/%.c $(OBJECTS)
	@echo 'Creating NIF: '$@
	@$(CC) $(CFLAGS) -shared $(OBJECTS) -o $@ $< $(LDFLAGS)

clean:
	@echo 'Cleaning up compiled files.'
	$(shell trash -F $(OBJECTS) $(NIFS_OBJECTS))
