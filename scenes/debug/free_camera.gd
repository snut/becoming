extends Spatial

const cam_speed = 2.0
const cam_sens = -0.01
const cam_inputs = {
	"free_camera_forward": Vector3(0,0,-1),
	"free_camera_backward": Vector3(0,0,1),
	"free_camera_left": Vector3(-1,0,0),
	"free_camera_right": Vector3(1,0,0),
	"free_camera_up": Vector3(0,1,0),
	"free_camera_down": Vector3(0,-1,0) }

onready var camera = $Camera

var mouse_delta := Vector2(0,0)

func _ready():
	pass


func _process(var dt: float):
	if !camera.current: return
	var move = Vector3(0,0,0)
	for k in cam_inputs:
		if Input.is_action_pressed(k):
			move += cam_inputs[k]
	var cam_move = Vector3(0,0,0)
	cam_move.y = move.y 
	cam_move += camera.transform.basis.x * move.x 
	cam_move += camera.transform.basis.z * move.z
	if cam_move.length_squared() > 0.0001:
		cam_move = cam_move.normalized()
	
	translation += cam_move * cam_speed * dt
	
	if Input.is_action_pressed("free_camera_look"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		camera.rotation.y += mouse_delta.x * cam_sens 
		camera.rotation.x += mouse_delta.y * cam_sens
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	mouse_delta = Vector2(0,0)

func _input(event):
	if event is InputEventMouseMotion:
		mouse_delta = event.relative
