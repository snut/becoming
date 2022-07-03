extends Spatial

export var size_x : int = 7
export var size_y : int = 4
export var size_z : int = 7

var tiles = []
var solidity = {}
var tile_geo = {}

func _ready():
	Hex.populate(tile_geo)
	for x in range(0, size_x):
		for y in range(0, size_y):
			for z in range(0, size_z):
				var solid = 0
				if y == 0: 
					solid = 1
				#elif randf() < 0.1: 
				#	solid = 1
				var v = Vector3(x,y,z)
				solidity[v] = solid 
				var tls = Hex.hex_to_tiles(x,y,z)
				for tl in tls:
					tiles.append(tl)
					add_child(tl)
	for tl in tiles:
		tl.assign_tile_index(solidity)
		tl.instantiate_geo(tile_geo)
					
				
	pass
