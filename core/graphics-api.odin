package core

import "base:runtime"

Graphics_Api_Type :: enum u8 {
	OpenGL = 0,
	Vulkan = 1,
}

Graphics_Api_Context :: union {
	OpenGL_Context,
	int, // temp
}

Graphics_Api :: struct {
	begin_render: proc(),
	render:       proc(^Graphics_Api_Context),
	end_render:   proc(),
	destroy:      proc(^Graphics_Api_Context),
	type:         Graphics_Api_Type,
	ctx:          Graphics_Api_Context,
}

