# Compiler and flags
CXX = g++
CXXFLAGS = -std=c++11 -Wall -Wextra -O2
LDFLAGS = 

# Targets
TARGETS = client server

# Client source files
CLIENT_SRCS = main.cpp TCPClient.cpp
CLIENT_OBJS = $(CLIENT_SRCS:.cpp=.o)
CLIENT_TARGET = client

# Server source files
SERVER_SRCS = server.cpp
SERVER_OBJS = $(SERVER_SRCS:.cpp=.o)
SERVER_TARGET = server

# Header files
HEADERS = TCPClient.h

# Default rule
all: $(TARGETS)

# Build client
$(CLIENT_TARGET): $(CLIENT_OBJS)
	$(CXX) $(CXXFLAGS) -o $@ $^ $(LDFLAGS)

# Build server
$(SERVER_TARGET): $(SERVER_OBJS)
	$(CXX) $(CXXFLAGS) -o $@ $^ $(LDFLAGS)

# Compilation rules for object files
%.o: %.cpp $(HEADERS)
	$(CXX) $(CXXFLAGS) -c $< -o $@

# Clean
clean:
	rm -f $(CLIENT_OBJS) $(SERVER_OBJS) $(TARGETS)

# Clean + rebuild
rebuild: clean all

# Run client
run-client: $(CLIENT_TARGET)
	./$(CLIENT_TARGET)

# Run server
run-server: $(SERVER_TARGET)
	./$(SERVER_TARGET)

# Run client with arguments
run-client-args: $(CLIENT_TARGET)
	./$(CLIENT_TARGET) $(ARGS)

# Debug build
debug: CXXFLAGS += -g -DDEBUG -O0
debug: all

# Profiling build
profile: CXXFLAGS += -pg
profile: all

# Syntax check
check:
	$(CXX) $(CXXFLAGS) -fsyntax-only $(CLIENT_SRCS) $(SERVER_SRCS)

# Show variables
vars:
	@echo "CXX = $(CXX)"
	@echo "CXXFLAGS = $(CXXFLAGS)"
	@echo "CLIENT_SRCS = $(CLIENT_SRCS)"
	@echo "SERVER_SRCS = $(SERVER_SRCS)"

# Set execute permissions
perms:
	chmod +x $(TARGETS)

# Help
help:
	@echo "Available commands:"
	@echo "  make all          - Build everything (default)"
	@echo "  make client       - Build only the client"
	@echo "  make server       - Build only the server"
	@echo "  make clean        - Remove object files and binaries"
	@echo "  make rebuild      - Clean and rebuild everything"
	@echo "  make run-client   - Build and run the client"
	@echo "  make run-server   - Build and run the server"
	@echo "  make debug        - Build with debugging information"
	@echo "  make profile      - Build with profiling support"
	@echo "  make check        - Check syntax without building"
	@echo "  make help         - Show this help message"
	@echo ""
	@echo "Examples:"
	@echo "  make run-client-args ARGS=\"127.0.0.1 11999\""
	@echo "  make run-server"

.PHONY: all clean rebuild run-client run-server run-client-args debug profile check vars perms help
