CXX = g++
CFLAGS = -std=c++17 -O2
LDFLAGS = -lglfw -lvulkan -ldl -lpthread -lX11 -lXxf86vm -lXrandr -lXi

# Shader compiler
GLSLANG_VALIDATOR = glslangValidator

# Shader source and compiled outputa
SHADERS = shaders/shader.vert shaders/shader.frag
SPV_SHADERS = $(SHADERS:.vert=.vert.spv)
SPV_SHADERS := $(SPV_SHADERS:.frag=.frag.spv)

# Main target
VulkanTest: main.cpp $(SPV_SHADERS)
	$(CXX) $(CFLAGS) -o VulkanTest main.cpp $(LDFLAGS)

# Shader compile rule
%.vert.spv: %.vert
	$(GLSLANG_VALIDATOR) -V $< -o $@

%.frag.spv: %.frag
	$(GLSLANG_VALIDATOR) -V $< -o $@

.PHONY: test clean shaders

# Run the program
test: VulkanTest
	./VulkanTest

# Clean everything
clean:
	rm -f VulkanTest $(SPV_SHADERS)

# Compile shaders only
shaders: $(SPV_SHADERS)
