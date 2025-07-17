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

	mesh := core.Mesh {
		vertices = {
			{position = {-0.1, -0.1, 0.0}, color = {1.0, 0.0, 0.0, 1.0}},
			{position = { 0.0,  0.1, 0.0}, color = {0.0, 1.0, 0.0, 1.0}},
			{position = { 0.1, -0.1, 0.0}, color = {0.0, 0.0, 1.0, 1.0}},
		},
	}
	core.register_mesh(&mesh)

	triangle := core.Entity{
		id = 0,
		position = {0.1, 0},
		mesh = &mesh,
	}
	triangle_2 := core.Entity{
		id = 0,
		position = {-0.1, 0},
		mesh = &mesh,
	}

	scene: core.Scene
	core.register_entity(&scene, &triangle)
	tri_2 := core.register_entity(&scene, &triangle_2)
	core.topic_info(.Temp, "Reached")

	for !core.window_should_close(&glfw_ctx, &scene) {
		tri_2.position.x += 0.0001
	}
}


