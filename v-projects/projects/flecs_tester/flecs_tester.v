import prime31.flecs

struct Pos {
mut:
	x int
	y int = 10
}

struct Vel {
mut:
	x int
	y int
}

struct Rot {
mut:
	x int
	y int
}

fn (p Pos) str() string {
	return 'x=$p.x, y=$p.y'
}

fn (v Vel) str() string {
	return 'x=$v.x, y=$v.y'
}

fn main() {
	println(' ---- ')
	world := C.ecs_init()
	pos_entity := C.ecs_new_component(world, "Position", sizeof(Pos))
	vel_entity := world.new_component("Velocity", sizeof(Vel))

	println('world=$world, pos_entity=$pos_entity, vel_entity=$vel_entity')

	pos_type := C.ecs_type_from_entity(world, pos_entity)
	vel_type := world.type_from_entity(vel_entity)
	println('pos_type=$pos_type, vel_type=$vel_type')

	sys_entity := C.ecs_new_system(world, "MoveSystem", C.EcsOnUpdate, "Position, !Velocity", move)
	println('sys_entity=$sys_entity')

	entity := C.ecs_new_entity(world, "My Entity", "Position")
	println('entity=$entity')

	entity2 := C.ecs_new_entity(world, "My Second Entity", "Position")
	println('entity2=$entity2')

	p := Pos{10, 10}
	C._ecs_set_ptr(world, entity, pos_entity, sizeof(Pos), &p)

	p2 := Pos{66, 66}
	C._ecs_set_ptr(world, entity2, pos_entity, sizeof(Pos), &p2)

	println(' ---- ')
	C.ecs_progress(world, 0.016)
	// C.ecs_progress(world, 0.016)
}

fn move(rows &C.ecs_rows_t) {
	println('rows=$rows, world=$rows.world, system=$rows.system, column_count=$rows.column_count, count=$rows.count, delta_time=$rows.delta_time')

	e1 := rows.entities[0]
	println('e1=$e1')

	println('column_count=$rows.column_count, column=1, size=${sizeof(Pos)}')
	mut positions := *Pos(C._ecs_column(rows, sizeof(Pos), 1))
	velocities := *Vel(C._ecs_column(rows, sizeof(Vel), 2))

	for i := 0; i < int(rows.count); i++ {
		println('pos[$i]=${positions[i]}')
		positions[i].x += 1
		positions[i].y += 10
	}
}
