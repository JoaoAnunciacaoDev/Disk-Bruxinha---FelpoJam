extends Sprite2D

@export var raycast_ground : RayCast2D
@export var raycast_wall : RayCast2D
@export var lerp_speed = 5
@export var target_position : Vector2 = Vector2.INF

var following_body_raycast : RayCast2D

func _process(delta: float) -> void:
	if raycast_wall.is_colliding():
		following_body_raycast = raycast_wall
		show()
	elif raycast_ground.is_colliding():
		following_body_raycast = raycast_ground
		show()
	else:
		hide()
	
	var collision_point : Vector2 = following_body_raycast.get_collision_point()
	global_position = lerp(following_body_raycast.global_position, collision_point, pow(0.5, delta * lerp_speed))
