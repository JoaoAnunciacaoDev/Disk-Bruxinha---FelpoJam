extends Sprite2D

@export var player : Player
@export var anim_player : AnimationPlayer
@export var raycast_ground : RayCast2D
@export var raycast_wall : RayCast2D
@export var lerp_speed = 10

func _process(delta: float) -> void:
	var collision_point : Vector2
	var stamped_point : Vector2i
	
	if raycast_wall.is_colliding():
		collision_point = raycast_wall.get_collision_point()
		stamped_point = player.world_tilemap.get_snapped_position(collision_point)
		
		if raycast_wall.scale.x < 0:
			global_position = stamped_point + Vector2i(-16, 16)
		else:
			global_position = stamped_point + Vector2i(16, 16)
		
		show()
		
	elif raycast_ground.is_colliding():
		collision_point = raycast_ground.get_collision_point()
		stamped_point = player.world_tilemap.get_snapped_position(collision_point)
		global_position = lerp(global_position, Vector2(stamped_point) + Vector2(16, 16), delta * lerp_speed)
		
		show()
	else:
		hide()

func play_squash() -> void:
	anim_player.play("squash")
