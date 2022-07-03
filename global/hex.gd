extends Node

# triangles are radius 1, so have a half-edge of sin(pi/3) = 0.8660254037844386
const half_edge_len := 0.8660254037844386
# edge length is also the distance between the hex centers
const edge_len := 2.0 * half_edge_len
# the perpendicular distance from an edge's midpoint to the centroid is cos(pi/3) = 0.5
const edge_to_center := 0.5

func hex_center(x:int, y:int, z:int):
	# remember godot is Wrong and y is up
	var odd = float(z % 2)
	var hx = float(x) + 0.5 * odd
	var hz = float(z) * sin(PI/3)
	var result = Vector3( hx * edge_len, float(y), hz * edge_len)
	return result

# each hex (prism) produces two triangle (prisms)
#.______.
# \  .  /\
#  \/ \/  \
#  /\ /\   \
# |  +--|---.
#  \   /

func hex_to_tiles(x: int, y: int, z: int):
	var hc = hex_center(x, y, z)
	var odd = z % 2
	
	var a = Tile.new()
	a.translation = hc + Vector3(half_edge_len, 0.0, -edge_to_center)
	a.hex_center = hc
	a.tile_y = y 
	a.vertex_a_x = x 
	a.vertex_a_z = z 
	a.vertex_b_x = x + 1
	a.vertex_b_z = z
	a.vertex_c_x = x + odd 
	a.vertex_c_z = z + 1
	
	var b = Tile.new()	
	b.translation = hc - Vector3(0.0, 0.0, 1.0)
	b.hex_center = hc
	b.translation.y -= 0.25
	b.rotation.y = PI
	b.tile_y = y
	b.vertex_a_x = x + odd 
	b.vertex_a_z = z + 1
	b.vertex_b_x = x + odd - 1
	b.vertex_b_z = z + 1 
	b.vertex_c_x = x
	b.vertex_c_z = z
	
	return [a, b]

# populate a dictionary of tile keys to meshes
func populate(tile_geo:Dictionary):
	for a in [0,1]:
		for b in [0,1]:
			for c in [0,1]:
				var abc = "%d%d%d" % [a,b,c]
				for d in [0,1]:
					for e in [0,1]:
						for f in [0,1]:
							var def = "%d%d%d" % [d,e,f]
							var file = "res://geo/tiles/tile_%s_%s.obj" % [abc, def]
							var key = a*1+b*2+c*4+d*8+e*16+f*32
							if key == 0 || key == 63:
								continue
							var geo = load(file)
							if geo:
								tile_geo[key] = geo

func _ready():
	pass
