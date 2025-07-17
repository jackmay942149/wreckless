package core

Mesh :: struct {
	opengl_vao: u32,
	vertices:   []Vertex,
}

Vertex :: struct {
	position: [3]f32,
	color:    [4]f32,
	uv:       [2]f32,
	normals:  [3]f32,
	tangent:  [3]f32,
	user:     [4]f32,
}

