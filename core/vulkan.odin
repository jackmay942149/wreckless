package core

import "vendor:glfw"
import vk "vendor:vulkan"

Vulkan_Context :: struct {
	instance: vk.Instance
}

init_vulkan :: proc(app_info: ^App_Info, allocator := context.allocator) -> (api: Graphics_Api) {
	context.allocator = allocator
	vk_ctx: Vulkan_Context

	vk_ctx.instance = create_instance(app_info)
	// TODO: Validation Layers
	// TODO: Get Physical Device

	api = {
		destroy = destroy_vulkan,
		render = render_vulkan,
		type = .Vulkan,
		ctx = vk_ctx,
	}
	return api
}

render_vulkan :: proc(graphics_api: ^Graphics_Api_Context, scene: ^Scene) {
	vk_ctx := &graphics_api.(Vulkan_Context)
}

destroy_vulkan :: proc(graphics_api: ^Graphics_Api_Context) {
	vk_ctx := &graphics_api.(Vulkan_Context)
}

@(private = "file")
vk_fatal :: proc(result: vk.Result, message: string) {
	if result == .SUCCESS do return
	topic_fatal(.Graphics, result, message)
}

@(private = "file")
create_instance :: proc(app: ^App_Info) -> (instance: vk.Instance){
	// Load fp's
	vk.load_proc_addresses_global(rawptr(glfw.GetInstanceProcAddress))
	assert(vk.CreateInstance != nil)
	// Get api version
	version: u32
	vk_result := vk.EnumerateInstanceVersion(&version)
	vk_fatal(vk_result, "Failed to get vulkan version this is likely due to vulkan version 1.0")
	topic_info(.Graphics, "I think this is api version:", version) // TODO: test what this is
	// Create app info
	app_info := vk.ApplicationInfo {
		sType              = .APPLICATION_INFO,
		pApplicationName   = app.title,
		applicationVersion = vk.MAKE_VERSION(1, 0, 0),
		pEngineName        = "Wreckless",
		engineVersion      = vk.MAKE_VERSION(1, 0, 0),
		apiVersion         = vk.MAKE_VERSION(1, 1, 0),
	}
	// Create instance TODO: Add debug report callback here as debug messenger is not setup yet
	info := vk.InstanceCreateInfo {
		sType                   = .INSTANCE_CREATE_INFO,
		pApplicationInfo        = &app_info,
		enabledExtensionCount   = u32(len(app.vk_global_extensions)),
		enabledLayerCount       = u32(len(app.vk_global_layers)),
		ppEnabledExtensionNames = raw_data(app.vk_global_extensions[:]),
		ppEnabledLayerNames     = raw_data(app.vk_global_layers[:]),
	}
	vk_result = vk.CreateInstance(&info, nil, &instance)
	topic_info(.Graphics, "Instance has address: ", instance, vk_result)
	vk_fatal(vk_result, "Failed to create instance")
	vk.load_proc_addresses_instance(instance)
	return instance
}
