package core

Scene :: struct {
	entities: [MAX_ENTITIES]Entity,
	occupied_list: [MAX_ENTITIES]bool,
}

register_entity :: proc(scene: ^Scene, entity: ^Entity) -> (^Entity){
	for occupied, i in scene.occupied_list {
		if occupied == false {
			entity.id = u32(i)
			scene.entities[i] = entity^
			scene.occupied_list[i] = true
			return &scene.entities[i]
		}
	}
	topic_fatal(.Core, "Too many entities")
	return nil
}
