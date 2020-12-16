# Makefile Template.

# .
# |-- Makefile (This file)
# |-- build
# |   `-- target file.
#     |-- obj
#         `-- object files.
# |-- include
# |   `-- header files.
# `-- source
#     `-- source files.

# Variables
## Directory defines
BUILDDIR = ./build
OBJDIR = $(BUILDDIR)/obj
SRCDIR = ./source
INCDIRS = ./include
LIBDIRS = #-L

## Target name
TARGET = $(BUILDDIR)/a.out

## Compiler options
CC = gcc
CFLAGS = -O2 -Wall
CXX = g++
CXXFLAGS = -O2 -Wall
LDFLAGS =

SRCS := $(shell find $(SRCDIR) -name *.cpp -or -name *.c -or -name *.s)
OBJS := $(SRCS:%=$(OBJDIR)/%.o)
DEPS := $(OBJS:.o=.d)
LIBS = #-lboost_system -lboost_thread

INCLUDE := $(shell find $(INCDIRS) -type d)
INCLUDE := $(addprefix -I,$(INCLUDE))

CPPFLAGS := $(INCLUDE) -MMD -MP
LDFLAGS += $(LIBDIRS) $(LIBS)

# Target
default:
	make all

all: $(TARGET)

$(TARGET): $(OBJS)
	$(CXX) -o $@ $^ $(LDFLAGS)

# assembly
$(OBJDIR)/%.s.o: %.s
	$(MKDIR_P) $(dir $@)
	$(AS) $(ASFLAGS) -c $< -o $@

# c source
$(OBJDIR)/%.c.o: %.c
	$(MKDIR_P) $(dir $@)
	$(CC) $(CPPFLAGS) $(CFLAGS) -c $< -o $@

# c++ source
$(OBJDIR)/%.cpp.o: %.cpp
	$(MKDIR_P) $(dir $@)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c $< -o $@
	
.PHONY: all clean rebuild

clean:
	$(RM) -r $(BUILDDIR)

rebuild:
	make clean && make

-include $(DEPS)

MKDIR_P = mkdir -p
