extends RayCast2D

@export var max_length : float = 32.0
@export var is_detecting_ground : bool
@export var cast_speed : float = 300.0

func _physics_process(delta: float) -> void:
	var collision_point : Vector2 = get_collision_point()
	var distance : float = (collision_point - global_position).length()
	
	if is_detecting_ground:
		if Input.is_action_pressed("down"):
			position.x = 0.0
		else:
			position.x = 32.0
		
		apply_target_position(delta, 0, distance)
		
	else:
		apply_target_position(delta, distance, 0)

func apply_target_position(delta : float, value_x : float, value_y : float) -> void:
	if is_colliding():
		target_position = Vector2(value_x, value_y)
	else:
		if is_detecting_ground:
			target_position.y = move_toward(target_position.y, max_length, cast_speed * delta)
		else:
			target_position.x = move_toward(target_position.x, max_length, cast_speed * delta)
