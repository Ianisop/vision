CXX = g++ -g3

VULKAN_SDK_PATH = /home/user/VulkanSDK/x.x.x.x/x86_64
STB_INCLUDE_PATH = /home/user/libraries/stb
TINYOBJ_INCLUDE_PATH = /home/user/libraries/tinyobjloader

CFLAGS = -std=c++17 -I$(VULKAN_SDK_PATH)/include -I$(STB_INCLUDE_PATH) -I$(TINYOBJ_INCLUDE_PATH) 
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
