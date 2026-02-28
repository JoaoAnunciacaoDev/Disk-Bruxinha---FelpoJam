extends StampEffect
class_name BreakEffect

@export var interval_time : float = 1.5
var prev_tile_pos : Vector2i
var prev_global_pos : Vector2i
var tilemap : WorldTileMap

func apply_effect(parent : Node2D, body : Node2D) -> void:
	var horizontal_velocity : float = abs(body.velocity.x)
	
	if not body.state_machine.current_state.name == "fall":
		if horizontal_velocity < 220.0: return
	
	if is_effect_active: return
	is_effect_active = true
	
	self.parent = parent
	
	prev_tile_pos = body.world_tilemap.get_coords(parent.global_position)
	prev_global_pos = body.world_tilemap.get_snapped_position(parent.global_position)
	tilemap = body.world_tilemap
	
	tilemap.erase_cell(prev_tile_pos)
	parent.hide()
	_on_timeout(body)

func timing_effect_duration(body : Node2D) -> void:
	if timer: return
	if not parent: return
	
	timer = Timer.new()
	timer.wait_time = interval_time
	timer.one_shot = true
	timer.timeout.connect(func():
		_on_timeout(body)
		timer.queue_free()
		)
		
	get_tree().root.add_child(timer)
	timer.start()

func _on_timeout(body : Node2D) -> void:
	await get_tree().create_timer(2.5).timeout
	if not parent.is_body_in:
		body.world_tilemap.set_cell(prev_tile_pos, 0, Vector2(0, 0))
		parent.call_deferred("queue_free")
		body.stamp_component.remove_stamp(prev_global_pos)
		body.stamp_component.locals_stamped.erase(prev_global_pos)
	else:
		timing_effect_duration(body)
