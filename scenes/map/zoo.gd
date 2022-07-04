tool
extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var tiles := {}


# populate a dictionary of tile keys to meshes
# duplicate of function in hex.gd because tool things maybe?
func populate(tile_geo: Dictionary):
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
	

func binary_string(val: int):
	var s = ""
	for i in range(0,6):
		if i == 3: s += "_"
		if (val & (1<<i)) == 0:
			s += "0"
		else:
			s += "1"
	return s

func _ready():
	for g in tiles.values():
		if Engine.editor_hint:
			g.set_owner(null)
		g.queue_free()
	tiles.empty()
		
	populate(tiles)
	for k in tiles:
		var g = tiles[k]
		var pos = Vector3(float(k%8) * 2.0, 0, float(k/8)*2.0)
		var m := MeshInstance.new()
		m.name = "test_%s" % binary_string(k)
		m.mesh = g
		m.translation = pos
		add_child(m)
		if Engine.editor_hint:
			m.set_owner(get_tree().edited_scene_root)
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
