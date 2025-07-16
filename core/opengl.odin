package core

import "core:os"
import gl "vendor:OpenGL"
import glfw "vendor:glfw"

// odinfmt: disable
mesh := Mesh {
	vertices = {
		{position = {-0.9, -0.9, 0.0}, color = {0.0, 0.0, 0.0, 1.0}},
		{position = { 0.9, -0.9, 0.0}, color = {0.0, 1.0, 0.0, 1.0}},
		{position = { 0.0,  0.9, 0.0}, color = {0.0, 0.0, 1.0, 1.0}},
	},
}
// odinfmt: enable

OpenGL_Context :: struct {
	shader_program: u32,
}

init_opengl :: proc(allocator := context.allocator) -> (api: Graphics_Api) {
	context.allocator = allocator
	gl_ctx: OpenGL_Context

	// Load opengl functions
	gl.load_up_to(4, 6, glfw.gl_set_proc_address)

	// Compile Shader
	ok: bool
	gl_ctx.shader_program, ok = gl.load_shaders_file(
		"core/assets/default.vert",
		"core/assets/default.frag",
	)
	if !ok {
		topic_fatal(.Graphics, "Failed to create shaders")
	}

	vbo, vao: u32
	gl.GenVertexArrays(1, &vao)
	gl.BindVertexArray(vao)
	gl.GenBuffers(1, &vbo)
	gl.BindBuffer(gl.ARRAY_BUFFER, vbo)
	gl.BufferData(
		gl.ARRAY_BUFFER,
		len(mesh.vertices) * size_of(mesh.vertices[0]),
		raw_data(mesh.vertices),
		gl.STATIC_DRAW,
	)
	gl.EnableVertexAttribArray(0)
	gl.VertexAttribPointer(0, 3, gl.FLOAT, false, size_of(Vertex), offset_of(Vertex, position))
	gl.EnableVertexAttribArray(1)
	gl.VertexAttribPointer(1, 4, gl.FLOAT, false, size_of(Vertex), offset_of(Vertex, color))

	gl.BindBuffer(gl.ARRAY_BUFFER, 0)

	api = Graphics_Api {
		destroy = destroy_opengl,
		render  = render_opengl,
		type    = .OpenGL,
		ctx     = gl_ctx,
	}
	return api
}

render_opengl :: proc(graphics_api: ^Graphics_Api_Context) {
	gl.ClearColor(0, 0, 0, 1)
	gl.Clear(gl.COLOR_BUFFER_BIT)
	gl.UseProgram(graphics_api.(OpenGL_Context).shader_program)
	gl.DrawArrays(gl.TRIANGLES, 0, 6)
}

destroy_opengl :: proc(gl_ctx: ^Graphics_Api_Context) {
	gl.DeleteShader(gl_ctx.(OpenGL_Context).shader_program)
}

