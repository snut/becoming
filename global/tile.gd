extends Spatial

class_name Tile

# the position of the hex center for this tile
var hex_center := Vector3(0,0,0)

# tile indices
# tile_y is the lower part of the prism 
# the tile may be rotated
# 
#   c      b---a
#  / \      \ /
# a---b      c
# 
# the other indices represent the integer coordinates of the hex tiles at each vertex
# there will be three more at tile_y + 1 to complete the prism
var tile_y : int = 0
var vertex_a_x : int = 0
var vertex_a_z : int = 0
var vertex_b_x : int = 0
var vertex_b_z : int = 0
var vertex_c_x : int = 0
var vertex_c_z : int = 0

# the tile index is found by looking up the solidity of the hex tiles at each vertex,
# with vertex_a/tile_y being the lsb, then vertex_b/tile_y.. vertex_c/tile_y+1
# giving a six-bit number
# 0 and 63 do not have any geometry, representing a totally empty/totally filled space
var tile_index : int = -1
var debug_index : String = ""

var tile_mesh : MeshInstance = null

func assign_tile_index(solidity_map : Dictionary):
	tile_index = 0
	var xs = [vertex_a_x, vertex_b_x, vertex_c_x]
	var zs = [vertex_a_z, vertex_b_z, vertex_c_z]
	debug_index = ""
	for bit in range(0,6):
		var x = xs[bit%3]
		var z = zs[bit%3]
		var y = tile_y + bit/3
		#print_debug("assign_tile_index", x, z, y)
		var dflt = 0
		if y == 0: dflt = 1
		var b = solidity_map.get(Vector3(x,y,z), dflt)
		assert(b == 1 || b == 0)
		tile_index |= b << bit
		if b == 1:
			debug_index += "1"
		elif b == 0:
			debug_index += "0"
		else:
			debug_index += "?"
	if tile_index > 0 && tile_index < 63:
		print("assign_tile_index: ", debug_index)
	pass

# the position and rotation of the geo are held in the transform of this tile
# so we can instantiate the actual geometry as a child
func instantiate_geo(tile_to_geo : Dictionary):
	if tile_mesh != null:
		tile_mesh.queue_free()
		tile_mesh = null
	var g = tile_to_geo.get(tile_index, null)
	if g == null:
		return
	var m = MeshInstance.new()
	m.mesh = g
	if rotation.y == 0:
		m.material_override = load("res://materials/tile_default.tres")
	else:
		m.material_override = load("res://materials/tile_alt.tres")
	tile_mesh = m
	add_child(m)
	
	#var dbg = MeshInstance.new()
	#dbg.mesh = SphereMesh.new()
	#dbg.scale = Vector3(0.1, 0.1, 0.1)
	#dbg.translation = transform.xform_inv(hex_center)
	#add_child(dbg)

func _ready():
	pass
