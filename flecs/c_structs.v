module flecs


struct C.ecs_world_t {}

struct C.ecs_type_t {}
pub fn (t &C.ecs_type_t) str() string { return '$&t' }

struct C.ecs_rows_t {
pub:
    world voidptr //ecs_world_t *world;          /* Current world */
    system u64 //ecs_entity_t system;         /* Handle to current system */

    columns &int //[]int //int32_t *columns;    /* Indices mapping system params to columns and refs */
    column_count u16 //uint16_t column_count;       /* Number of columns for system */
    table voidptr //void *table;                 /* Opaque structure with reference to table */
    table_columns voidptr //void *table_columns;         /* Opaque structure with table column data */
    references voidptr //ecs_reference_t *references; /* References to other entities */
    components &u64 //ecs_entity_t *components;    /* System-table specific list of components */
    entities &u64 //ecs_entity_t *entities;      /* Entity row */

    param voidptr //void *param;                 /* Userdata passed to on-demand system */
    delta_time f32 //float delta_time;            /* Time elapsed since last frame */
    world_time f32 //float world_time;            /* Time elapsed since start of simulation */
    frame_offset u32 //uint32_t frame_offset;       /* Offset relative to frame */
    table_offset u32 //uint32_t table_offset;       /* Current active table being processed */
    offset u32 //uint32_t offset;             /* Offset relative to current table */
    count u32 //uint32_t count;              /* Number of rows to process by system */

    interrupted_by u64 //ecs_entity_t interrupted_by; /* When set, system execution is interrupted */
}
