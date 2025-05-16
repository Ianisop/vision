CXX = g++ -g3

VULKAN_SDK_PATH = /home/user/VulkanSDK/x.x.x.x/x86_64
STB_INCLUDE_PATH = /home/user/libraries/stb
TINYOBJ_INCLUDE_PATH = /home/user/libraries/tinyobjloader
IMGUI_DIR = imgui
IMGUI_BACKENDS = $(IMGUI_DIR)/backends
IMGUI_SRCS = \
	$(IMGUI_DIR)/imgui.cpp \
	$(IMGUI_DIR)/imgui_draw.cpp \
	$(IMGUI_DIR)/imgui_tables.cpp \
	$(IMGUI_DIR)/imgui_demo.cpp \
	$(IMGUI_DIR)/imgui_widgets.cpp \
	$(IMGUI_BACKENDS)/imgui_impl_glfw.cpp \
	$(IMGUI_BACKENDS)/imgui_impl_vulkan.cpp

CFLAGS = -std=c++17 -I$(VULKAN_SDK_PATH)/include -I$(STB_INCLUDE_PATH) -I$(TINYOBJ_INCLUDE_PATH) -I$(IMGUI_DIR) -I$(IMGUI_BACKENDS)
LDFLAGS = -lglfw -lvulkan -ldl -lpthread -lX11 -lXxf86vm -lXrandr -lXi


# Shader compiler
GLSLANG_VALIDATOR = glslangValidator

# Shader source and compiled outputa
SHADERS = shaders/shader.vert shaders/shader.frag
SPV_SHADERS = $(SHADERS:.vert=.vert.spv)
SPV_SHADERS := $(SPV_SHADERS:.frag=.frag.spv)

# Main target
VulkanTest: main.cpp $(SPV_SHADERS) $(IMGUI_SRCS)
	$(CXX) $(CFLAGS) -o VulkanTest main.cpp $(IMGUI_SRCS) $(LDFLAGS)


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
