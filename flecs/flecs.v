module flecs


pub struct Entity {
	id u64
	world &C.ecs_world_t
}

pub fn (e Entity) str() string { return 'id=$e.id, world=$e.world' }