extends RayCast2D

@export var max_length : float = 40.0
@export var raycast_base : RayCast2D

func _physics_process(delta: float) -> void:
	var collision_point : Vector2 = get_collision_point()
	var distance : float = (collision_point - global_position).length()
	
	if raycast_base:
		if raycast_base.scale.x > 0:
			position.x = raycast_base.target_position.x
		else:
			position.x = -raycast_base.target_position.x
		
		apply_target_position(0, distance)
	else:
		apply_target_position(distance, 0)

func apply_target_position(value_x : float, value_y : float) -> void:
	if is_colliding():
		target_position = Vector2(value_x, value_y)
	else:
		if value_x > 0:
			target_position = Vector2(max_length, 0)
		else:
			target_position = Vector2(0, max_length)
