extends CharacterBody3D

var path_target = Vector3.ZERO
var time_accum := 0.0
var wanderer_speed = 10

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	Wanderer_Movement()
	
	time_accum += delta
	if time_accum >= 5.0:
		pathfinding()
		time_accum = 0.0
	
	if(position.distance_to(path_target) < 0.5): velocity = Vector3.ZERO; move_and_slide()


func pathfinding():
	path_target.x = randf_range(position.x - 10.0, position.x + 10.0)
	path_target.z = randf_range(position.z - 10.0, position.z + 10.0)
	path_target.y = position.y
	
	if(is_on_floor_Vec3(path_target)):
		print_debug("Found wanderer path at: ", path_target)
		
		velocity.x = path_target.x
		velocity.z = path_target.z
	
	var dir = (path_target - position).normalized()
	velocity.x = dir.x * wanderer_speed
	velocity.z = dir.z * wanderer_speed


# To zrozum w 100% bo te query i result jest jakieś upośledzone
func is_on_floor_Vec3(from):
	var space_state = get_world_3d().direct_space_state
	var to = from - Vector3.DOWN * 20.0
	var query = PhysicsRayQueryParameters3D.create(from, to)
	var result = space_state.intersect_ray(query)
	
	return result.size() > 0


func Wanderer_Movement():
	if(!is_on_floor()): velocity.y += get_gravity().y * get_process_delta_time() * 10
	if(is_on_ceiling()): velocity.y = 0
	
	move_and_slide()
