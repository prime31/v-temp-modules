module flecs


fn C.ecs_init() &C.ecs_world_t

// can't get by V compiler to let this work
// fn C.ECS_COMPONENT(world C.ecs_world_t, id voidptr)

fn C.ecs_new_component(world C.ecs_world_t, id string, size i64) u64
// world_t, entity_t -> type_t

fn C.ecs_type_from_entity(world C.ecs_world_t, entity u64) &C.ecs_type_t
// action is fn(voidptr)

fn C.ecs_new_system(world C.ecs_world_t, id string, system_kind int, sig string, action voidptr) u64
// ecs_entity_t ecs_new_system(
//     ecs_world_t *world,
//     const char *id,
//     EcsSystemKind kind,
//     const char *sig,
//     ecs_system_action_t action)
// typedef void (*ecs_system_action_t)(ecs_rows_t *data);

fn C.ecs_new_entity(world C.ecs_world_t, id string, components string) u64
// ecs_entity_t ecs_new_entity(
//     ecs_world_t *world,
//     const char *id,
//     const char *components);

fn C._ecs_new(world C.ecs_world_t, type_id C.ecs_type_t) u64
// ecs_entity_t _ecs_new(
//     ecs_world_t *world,
//     ecs_type_t type)

fn C._ecs_set_ptr(world C.ecs_world_t, entity u64, comp_entity u64, size i64, ptr voidptr) u64
// ecs_entity_t _ecs_set_ptr(
//     ecs_world_t *world,
//     ecs_entity_t entity,
//     ecs_entity_t component,
//     size_t size,
//     void *ptr)

fn C.ecs_progress(world C.ecs_world_t, delta_time f32) bool
// bool ecs_progress(
//     ecs_world_t *world,
//     float delta_time)

fn C._ecs_column(rows C.ecs_world_t, size i64, column u32) voidptr
// void* _ecs_column(
//     ecs_rows_t *rows,
//     size_t size,
//     uint32_t column)

// not possible yet...
// pub fn (r &Rows) ecs_column<T>(column u32) []T {
//     ptr := C._ecs_collumn(r, sizeof(T), column)
//     return *T(ptr)
// }