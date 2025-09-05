extends CharacterBody3D

# Take cam to do things with it later
@onready var camera = $Camera3D

# Vars delta time type
var mouse_delta = Vector2.ZERO
var mousepos = Vector2.ZERO
var vertical_rotation_of_camera_now = 0.0
var player_dir = Vector3.ZERO

# Vars speed type
var sensitivity = 0.1
var speed = 10
var jump_velocity = 20
var player_gravity = 5


func _ready() -> void:
	# Zablokuj myszkę
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _process(delta: float) -> void:
	# Get mousepos based on mouse_delta
	mousepos += mouse_delta
	
	CameraMovment()
	Movment()
	
	# Reset mouse delta for next frame
	mouse_delta = Vector2.ZERO

func _input(event: InputEvent) -> void:
	# Weś mouse delta
	if event is InputEventMouseMotion: mouse_delta = event.relative; print_debug("Delta = ", mouse_delta); print_debug("Pos = ", mousepos)


func CameraMovment():
	rotation_degrees.y -= mouse_delta.x * sensitivity
	vertical_rotation_of_camera_now -= mouse_delta.y * sensitivity
	# Clamp cut's value to selected spectrum, so it will be from -89 to 89 so just making only 90 degrees of rotation on one side possible
	vertical_rotation_of_camera_now = clamp(vertical_rotation_of_camera_now, -89, 89)
	camera.rotation_degrees.x = vertical_rotation_of_camera_now

func Movment():
	player_dir = Vector3.ZERO
	
	if(Input.is_action_pressed("w")):
		player_dir.z -= 1
	if(Input.is_action_pressed("s")):
		player_dir.z += 1
	if(Input.is_action_pressed("a")):
		player_dir.x -= 1
	if(Input.is_action_pressed("d")):
		player_dir.x += 1
	
	player_dir = player_dir.normalized()
	player_dir = global_transform.basis * player_dir
	
	velocity.x = player_dir.x * speed
	velocity.z = player_dir.z * speed
	
	if(!is_on_floor()): velocity.y -= 0.1 * player_gravity
	if(is_on_floor() && Input.is_action_pressed("jump")): velocity.y += jump_velocity
	if(is_on_ceiling()): velocity.y = 0
	
	move_and_slide();
