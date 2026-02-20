extends StampEffect
class_name BreakEffect

@export var interval_time : float = 1.0
var prev_tile_pos : Vector2i
var parent : StampInstance
var tilemap : WorldTileMap

func apply_effect(parent : Node2D, body : Node2D) -> void:
	if is_effect_active: return
	is_effect_active = true
	
	self.parent = parent
	
	var tile_pos : Vector2i = body.world_tilemap.get_coords(parent.global_position)
	prev_tile_pos = tile_pos
	tilemap = body.world_tilemap
	
	timing_effect_duration(body)
	
	print("APAGO")

func timing_effect_duration(body : Node2D) -> void:
	if timer: return
	
	timer = Timer.new()
	timer.wait_time = interval_time
	timer.one_shot = true
	timer.timeout.connect(func():
		tilemap.erase_cell(prev_tile_pos)
		parent.hide()
		_on_timeout(body)
		)
		
	get_tree().root.add_child(timer)
	timer.start()

func _on_timeout(body : Node2D) -> void:
	await get_tree().create_timer(1.0).timeout
	body.world_tilemap.set_cell(prev_tile_pos, 0, Vector2(0, 0))
	parent.call_deferred("queue_free")
