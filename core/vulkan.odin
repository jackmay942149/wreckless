package core

Vulkan_Context :: struct {
	temp: int,
}

init_vulkan :: proc(allocator := context.allocator) -> (api: Graphics_Api) {
	context.allocator = allocator
	vk_ctx: Vulkan_Context
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
