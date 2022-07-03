tool
extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var tiles := {}


	

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
		
	Hex.populate(tiles)
	for k in tiles:
		var g = tiles[k]
		var pos = Vector3(float(k) * 1.5, 0, 0)
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
