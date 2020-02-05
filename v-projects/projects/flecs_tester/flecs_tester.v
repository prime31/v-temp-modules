import via.libs.flecs

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

pub fn (p Pos) str() string {
	return 'x=$p.x, y=$p.y'
}

pub fn (v Vel) str() string {
	return 'x=$v.x, y=$v.y'
}

fn main() {
	world := flecs.init_world()
	pos_entity := world.new_component<Pos>('Position')
	vel_entity := world.new_component<Vel>('Velocity')

	println('world=$world, pos_entity=$pos_entity, vel_entity=$vel_entity')

	pos_type := pos_entity.type_from_entity()
	vel_type := vel_entity.type_from_entity()
	println('pos_type=$pos_type, vel_type=$vel_type')

	test := ecs_type_to_entity(world.world, pos_type)
	println('type_to_entity: $test')

	sys_entity := world.new_system('MoveSystem', .on_update, 'Position, !Velocity', move)
	println('sys_entity=$sys_entity')

	entity := world.new_entity('My Entity', 'Position')
	println('entity: $entity')

	entity2 := world.new_entity('My Second Entity', 'Position')
	println('entity2: $entity2')

	p := Pos{10, 10}
	entity.set_ptr_t(pos_entity, p)

	p2 := Pos{66, 66}
	entity2.set_ptr(pos_entity, sizeof(Pos), &p2)

	println(' ---- ')
	world.progress(0.016)
	world.progress(0.016)
}

fn move(rows &C.ecs_rows_t) {
	println('rows=$rows, world=$rows.world, system=$rows.system, column_count=$rows.column_count, count=$rows.count, delta_time=$rows.delta_time')

	e1 := rows.entities[0]
	println('e1=$e1')

	println('column_count=$rows.column_count, column=1, size=${sizeof(Pos)}')
	mut positions := rows.column<Pos>(1)
	velocities := *Vel(C._ecs_column(rows, sizeof(Vel), 2))

	for i := 0; i < int(rows.count); i++ {
		println('pos[$i]: ${positions[i]}')
		positions[i].x++
		positions[i].y += 10
	}
}