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
	window:       glfw.WindowHandle,
	graphics_api: Graphics_Api,
}

App_Info :: struct {
	width:        i32,
	height:       i32,
	title:        cstring,
	graphics_api: Graphics_Api_Type,
	monitor:      Maybe(u32),
}

init_window :: proc(app_info: ^App_Info, allocator:= context.allocator) -> (glfw_ctx: GLFW_Context) {
	context.allocator = allocator
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

	glfw_ctx.window = select_monitor(app_info)
	glfw.MakeContextCurrent(glfw_ctx.window)

	switch app_info.graphics_api {
	case .OpenGL:	glfw_ctx.graphics_api = init_opengl()
	case .Vulkan:	return {}
	}

	topic_info(.Core, "Initialised window")
	return glfw_ctx
}

@(private = "file")
select_monitor :: proc(app_info: ^App_Info) -> (window: glfw.WindowHandle) {
	monitors := glfw.GetMonitors()
	monitor_id, selected := app_info.monitor.?
	if !selected {
		window = glfw.CreateWindow(
			app_info.width,
			app_info.height,
			app_info.title,
			nil,
			nil,
		)
	} else {
		if app_info.monitor.(u32) > u32(len(monitors)) {
			topic_error(.Core, "Monitor", app_info.monitor, "is unavailable")
			window = glfw.CreateWindow(
				app_info.width,
				app_info.height,
				app_info.title,
				nil,
				nil,
			)
		} else {
			window = glfw.CreateWindow(
				app_info.width,
				app_info.height,
				app_info.title,
				monitors[app_info.monitor.(u32)],
				nil,
			)
		}
	}
	return window
}

window_should_close :: proc(glfw_ctx: ^GLFW_Context) -> bool {
	glfw_ctx.graphics_api.render(&glfw_ctx.graphics_api.ctx)
	glfw.SwapBuffers(glfw_ctx.window)
	glfw.PollEvents()
	return bool(glfw.WindowShouldClose(glfw_ctx.window))
}

destroy_window :: proc(glfw_ctx: ^GLFW_Context) { 	
	assert(glfw_ctx.window != nil)
	glfw_ctx.graphics_api.destroy(&glfw_ctx.graphics_api.ctx)
	glfw.DestroyWindow(glfw_ctx.window)
	glfw.Terminate()
	glfw_ctx.window = nil
	log.info("Closed window")
}

/*
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

