extends CharacterBody3D

# Take cam to do things with it later
@onready var camera = $Camera3D

# Vars delta time type
var mouse_delta = Vector2.ZERO
var mousepos = Vector2.ZERO
var vertical_rotation_of_camera_now = 0.0

# Vars speed type
var sensitivity = 0.1
var speed = 10


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
	if(Input.is_action_pressed("w")):
		velocity.x = 1 * speed
	elif(Input.is_action_pressed("s")):
		velocity.x = -1 * speed
	elif(Input.is_action_pressed("a")):
		velocity.z = 1 * speed
	elif(Input.is_action_pressed("d")):
		velocity.z = -1 * speed
	
	move_and_slide();
	
	velocity = Vector3.ZERO
