extends Camera2D
class_name PlayerCamera

@export var player : Player
@export var tilemap : WorldTileMap

@export var horizontal_dead_zone : float = 15.0
@export var vertical_dead_zone : float = 15.0
@export var follow_speed : float = 210.0

func setup_camera_limits() -> void:
	global_position = player.global_position
	
	var used_rect : Rect2i = tilemap.get_used_rect()
	var cell_size : Vector2 = tilemap.tile_set.tile_size
	var map_width : float = used_rect.size.x * cell_size.x
	var map_height : float = used_rect.size.y * cell_size.y
	
	limit_left = used_rect.position.x * cell_size.x
	limit_right = limit_left + map_width
	limit_top = used_rect.position.y * cell_size.y
	limit_bottom = limit_top + map_height

func update_camera_position(delta : float) -> void:
	if not player: return
	
	var player_pos : Vector2 = player.global_position
	var camera_pos : Vector2 = global_position
	var viewport_size : Vector2 = get_viewport_rect().size / zoom
	
	var target_pos : Vector2 = camera_pos
	
	if abs(player_pos.x - camera_pos.x) > horizontal_dead_zone:
		target_pos.x = player_pos.x
	
	if player_pos.y < (camera_pos.y -vertical_dead_zone):
		target_pos.y = player_pos.y
	elif player_pos.y > (camera_pos.y + vertical_dead_zone):
		target_pos.y = player_pos.y
	
	var min_x : float = limit_left + viewport_size.x / 3
	var max_x : float = limit_right - viewport_size.x / 3
	var min_y : float = limit_top + viewport_size.y / 3
	var max_y : float = limit_bottom - viewport_size.y / 3
	
	position.x = move_toward(position.x, target_pos.x, follow_speed * delta)
	
	if player_pos.y > camera_pos.y:
		position.y = move_toward(position.y, target_pos.y, player.velocity.y * delta)
	else:
		position.y = move_toward(position.y, target_pos.y, follow_speed * delta)

func _ready() -> void:
	tilemap = player.world_tilemap
	setup_camera_limits()

func _physics_process(delta: float) -> void:
	update_camera_position(delta)
