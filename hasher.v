import via.math

// TODO: should be an interface
struct Collider {
pub mut:
	x f32
	y f32
	w f32
	h f32
}
pub fn (h1 &Collider) eq(h2 &Collider) bool {
	return h1.x == h2.x && h1.y == h2.y && h1.w == h2.w && h1.h == h2.h
}
pub fn (i &Collider) get_bounds() Rect {
	return Rect{i.x as int, i.y as int, i.w as int, i.h as int}
}


struct Rect {
pub mut:
	x int
	y int
	w int
	h int
}
pub fn (r &Rect) str() string { return '$r.x, $r.y, $r.w, $r.h' }
pub fn (r &Rect) right() int { return r.x + r.w }
pub fn (r &Rect) bottom() int { return r.y + r.h }
pub fn (r1 &Rect) overlaps(r2 &Rect) bool {
	return r2.x < r1.x + r1.right() && r1.x < r2.right() && r2.y < r1.bottom() && r1.y < r2.bottom()
}
pub fn (r &Rect) contains(x, y int) bool {
	return r.x <= x && x < r.right() && y <= y && y < r.bottom()
}
pub fn (r1 &Rect) union_rect(r2 &Rect) Rect {
	mut res := Rect{}
	res.x = int(math.min(r1.x, r2.x))
	res.y = int(math.min(r1.y, r2.y))
	res.w = int(math.max(r1.right(), r2.right())) - res.x
	res.h = int(math.max(r1.bottom(), r2.bottom())) - res.y
	return res
}
pub fn (r1 &Rect) union_pt(x, y int) Rect {
	return r1.union_rect(Rect{x, y, 0, 0})
}





pub struct SpatialHash {
	cells map[string][]int
	items map[string]HashItem
	cell_size int = 32
	inv_cell_size f32 = 1.0 / 32.0
mut:
	id_counter int
	bounds Rect
}

struct HashItem {
mut:
	collider Collider
	bounds Rect
}

fn (sh &SpatialHash) get_hashed_key(x, y f32) u64 {
	return u64(x) << 32 | u32(y)
}

// gets the cell x,y values for a world-space x,y value
fn (sh &SpatialHash) cell_coords(x, y f32) (int, int) {
	return math.ifloor(x * sh.inv_cell_size), math.ifloor(y * sh.inv_cell_size)
}

fn (sh &SpatialHash) cell_coordsi(x, y int) (int, int) {
	return math.ifloor(f32(x) * sh.inv_cell_size), math.ifloor(f32(y) * sh.inv_cell_size)
}

fn (sh mut SpatialHash) cell_at_position(x, y int, create_if_absent bool) []int {
	key := sh.get_hashed_key(x, y)
	if key.str() in sh.cells {
		return sh.cells[key.str()]
	} else {
		if create_if_absent {
			// TODO: why does an array resize break the map?
			sh.cells[key.str()] = make(10, 10, sizeof(int))
			return sh.cells[key.str()]
		}
	}
	
	println('--------- dont ever get here')
	return []!
}

fn (sh mut SpatialHash) add(collider Collider) int {
	id := sh.id_counter++
	
	bounds := collider.get_bounds()
	p1x, p1y := sh.cell_coords(bounds.x, bounds.y)
	p2x, p2y := sh.cell_coords(bounds.right(), bounds.bottom())
	
	if !sh.bounds.contains(p1x, p1y) {
		sh.bounds = sh.bounds.union_pt(p1x, p1y)
	}
	if !sh.bounds.contains(p2x, p2y) {
		sh.bounds = sh.bounds.union_pt(p2x, p2y)
	}
	println('b: $sh.bounds.x, $sh.bounds.y, $sh.bounds.w, $sh.bounds.h')
	
	for x := p1x; x <= p2x; x++ {
		for y := p1y; y <= p2y; y++ {
			mut cell := sh.cell_at_position(x, y, true)
			cell << id
		}
	}
	
	sh.items[id.str()] = HashItem{collider, bounds}
	return id
}

fn (sh mut SpatialHash) remove(id int) {
	item := sh.items[id.str()]
	p1x, p1y := sh.cell_coords(item.bounds.x, item.bounds.y)
	p2x, p2y := sh.cell_coords(item.bounds.right(), item.bounds.bottom())
	
	for x := p1x; x <= p2x; x++ {
		for y := p1y; y <= p2y; y++ {
			mut cell := sh.cell_at_position(x, y, false)
			cell.delete(id)
		}
	}
	
	sh.items.delete(id.str())
}

fn (sh mut SpatialHash) update(id int, collider Collider) {
	mut item := sh.items[id.str()]
	
	// remove from all occupied cells
	mut p1x, mut p1y := sh.cell_coords(item.bounds.x, item.bounds.y)
	mut p2x, mut p2y := sh.cell_coords(item.bounds.right(), item.bounds.bottom())
	
	for x := p1x; x <= p2x; x++ {
		for y := p1y; y <= p2y; y++ {
			mut cell := sh.cell_at_position(x, y, false)
			cell.delete(id)
		}
	}
	
	// add to new cells
	bounds := collider.get_bounds()
	p1x, p1y = sh.cell_coords(bounds.x, bounds.y)
	p2x, p2y = sh.cell_coords(bounds.right(), bounds.bottom())
	
	for x := p1x; x <= p2x; x++ {
		for y := p1y; y <= p2y; y++ {
			mut cell := sh.cell_at_position(x, y, true)
			cell << id
		}
	}
	
	item.bounds = bounds
	sh.items[id.str()] = item
}

fn (sh &SpatialHash) debug() {
	
}




fn main() {
	mut h1 := Collider{0, 0, 10, 30}
	//mut h2 := Collider{30, 20, 10, 33}
	
	mut hash := SpatialHash{}
	h1_id := hash.add(h1)
	h1.x += 34
	hash.update(h1_id, h1)
	hash.remove(h1_id)
}