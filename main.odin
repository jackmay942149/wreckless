package main

import "./core"

main :: proc() {
	context.logger = core.init_logger(.Jack, .All)
	tracking_allocator, allocator := core.init_tracker()
	context.allocator = allocator
	defer {
		defer {
			core.assert_tracker_empty(tracking_allocator)
			core.destroy_tracker(tracking_allocator)
		}		
	}

	app_info := core.App_Info {
		width = 400,
		height  = 400,
		title = "Example Window",
		graphics_api = .OpenGL,
	}
	glfw_ctx := core.init_window(&app_info)

	for !core.window_should_close(&glfw_ctx) {
				
	}
}


