module flecs


pub fn (w &C.ecs_world_t) str() string { return '${&w}' }

pub fn (w &C.ecs_world_t) new_component(id string, size i64) u64 {
	return C.ecs_new_component(w, id.str, size)
}

pub fn (w &C.ecs_world_t) type_from_entity(entity u64) &C.ecs_type_t {
	return C.ecs_type_from_entity(w, entity)
}

pub fn (w &C.ecs_world_t) new_system(id string, system_kind int, sig string, action voidptr) u64 {
	return C.ecs_new_system(w, id.str, system_kind, sig.str, action)
}

pub fn (w &C.ecs_world_t) new_entity(id string, components string) Entity {
	return Entity {
		id: C.ecs_new_entity(w, id.str, components.str)
		world: w
	}
}

pub fn (w &C.ecs_world_t) progress(delta_time f32) bool {
	return C.ecs_progress(w, delta_time)
}