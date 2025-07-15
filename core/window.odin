package core

import "base:runtime"
import "core:fmt"
import "core:log"
import "core:os"
import "core:slice"
import "core:strings"
import "vendor:glfw"
import vk "vendor:vulkan"

GLFW_Context :: struct {
	window: glfw.WindowHandle,
}

App_Info :: struct {
	width:        i32,
	height:       i32,
	title:        cstring,
	graphics_api: Graphics_Api,
	monitor:      Maybe(u32),
}

@(private)
odin_ctx: runtime.Context
@(private)
glfw_ctx: GLFW_Context

init_window :: proc(app_info: ^App_Info) -> GLFW_Context {
	odin_ctx = context
	assert(glfw_ctx.window == nil)
	glfw.Init()
	glfw.WindowHint(glfw.RESIZABLE, glfw.TRUE)
	glfw.WindowHint(glfw.MAXIMIZED, glfw.FALSE)
	switch app_info.graphics_api {
	case .OpenGL:
		glfw.WindowHint(glfw.CLIENT_API, glfw.OPENGL_API)
	case .Vulkan:
		glfw.WindowHint(glfw.CLIENT_API, glfw.NO_API)
	}
	
	// Select monitor food display
	monitors := glfw.GetMonitors()
	monitor_id, selected := app_info.monitor.?
	if !selected {
		glfw_ctx.window = glfw.CreateWindow(
			app_info.width,
			app_info.height,
			app_info.title,
			nil,
			nil,
		)
	} else {
		if app_info.monitor.(u32) > u32(len(monitors)) {
			topic_error(.Core, fmt.aprint("Monitor %i is unavailable", app_info.monitor))
			app_info.monitor = nil
		}
		glfw_ctx.window = glfw.CreateWindow(
			app_info.width,
			app_info.height,
			app_info.title,
			monitors[app_info.monitor.(u32)],
			nil,
		)
	}
	glfw.MakeContextCurrent(glfw_ctx.window)
	// init_vulkan(glfw_ctx.window)
	log.info("Initialised window")
	return glfw_ctx
}

window_should_close :: proc() -> bool {
	glfw.SwapBuffers(glfw_ctx.window)
	glfw.PollEvents()
	//draw_frame()
	// vk_assert(vk.DeviceWaitIdle(vk_ctx.logical_device), "Failed to wait for synchronisation")
	return bool(glfw.WindowShouldClose(glfw_ctx.window))
}

/*
destroy_window :: proc() { 	// TODO: have a destroy vulkan function
	assert(glfw_ctx.window != nil)
	assert(vk_ctx.instance != nil)
	vk_assert(vk.DeviceWaitIdle(vk_ctx.logical_device), "Failed to wait for synchronisation")
	delete(vk_ctx.avail_extensions)
	delete(vk_ctx.avail_validation_layers)
	cleanup_swapchain(true)
	vk.DestroyDescriptorSetLayout(vk_ctx.logical_device, vk_ctx.descriptor_set_layout, nil)
	vk.DestroySemaphore(vk_ctx.logical_device, vk_ctx.image_avail_semaphore, nil)
	vk.DestroySemaphore(vk_ctx.logical_device, vk_ctx.render_finished_semaphore, nil)
	vk.DestroyFence(vk_ctx.logical_device, vk_ctx.in_flight_fence, nil)
	vk.DestroyBuffer(vk_ctx.logical_device, vk_ctx.vertex_buffer, nil)
	vk.FreeMemory(vk_ctx.logical_device, vk_ctx.vertex_buffer_memory, nil)
	vk.DestroyBuffer(vk_ctx.logical_device, vk_ctx.index_buffer, nil)
	vk.FreeMemory(vk_ctx.logical_device, vk_ctx.index_buffer_memory, nil)
	vk.DestroyCommandPool(vk_ctx.logical_device, vk_ctx.command_pool, nil)
	vk.DestroyPipeline(vk_ctx.logical_device, vk_ctx.graphics_pipeline, nil)
	vk.DestroyPipelineLayout(vk_ctx.logical_device, vk_ctx.pipeline_layout, nil)
	vk.DestroyRenderPass(vk_ctx.logical_device, vk_ctx.render_pass, nil)
	delete(vk_ctx.swapchain_images)
	vk.DestroySurfaceKHR(vk_ctx.instance, vk_ctx.surface, nil)
	vk.DestroyDevice(vk_ctx.logical_device, nil)
	vk.DestroyDebugUtilsMessengerEXT(vk_ctx.instance, vk_ctx.debug_messenger, nil)
	vk.DestroyInstance(vk_ctx.instance, nil)
	vk_ctx.instance = nil
	glfw.DestroyWindow(glfw_ctx.window)
	glfw.Terminate()
	glfw_ctx.window = nil
	log.info("Closed window")
}

maximise_window :: proc() {
	glfw.MaximizeWindow(glfw_ctx.window)
}

borderless_window :: proc() {
	monitor := glfw.GetPrimaryMonitor()
	borderless := glfw.GetVideoMode(monitor)
	glfw.SetWindowMonitor(
		glfw_ctx.window,
		monitor,
		0,
		0,
		borderless.width,
		borderless.height,
		borderless.refresh_rate,
	)
}

set_window_title :: proc(title: string) {
	c := strings.clone_to_cstring(title, context.allocator)
	defer delete(c)
	glfw.SetWindowTitle(glfw_ctx.window, c)
}

close_window :: proc() {
	glfw.SetWindowShouldClose(glfw_ctx.window, true)
}
*/

