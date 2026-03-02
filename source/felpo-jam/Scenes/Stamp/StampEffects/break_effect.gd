extends StampEffect
class_name BreakEffect

@export var restore_delay : float = 2.5
@export var retry_interval : float = 1.5

var restore_timer : Timer
var prev_tile_pos : Vector2i
var prev_global_pos : Vector2i
var tilemap : WorldTileMap
var affected_body : Node2D

func _ready() -> void:
	restore_timer = Timer.new()
	restore_timer.one_shot = true
	restore_timer.timeout.connect(_on_restore_timeout)
	add_child(restore_timer)

func apply_effect(parent_node : Node2D, body : Node2D) -> void:
	if not body.state_machine.current_state.name == "fall":
		if body.move_component.speed_multiplier <= 1.0 or body.state_machine.current_state.name == "idle": return
	
	if is_effect_active: return
	is_effect_active = true
	
	self.parent = parent_node
	self.affected_body = body
	
	prev_tile_pos = body.world_tilemap.get_coords(parent.global_position)
	prev_global_pos = body.world_tilemap.get_snapped_position(parent.global_position)
	tilemap = body.world_tilemap
	
	tilemap.erase_cell(prev_tile_pos)
	parent.hide()
	
	restore_timer.start(restore_delay)

func _on_restore_timeout() -> void:
	if not is_instance_valid(parent): return
	
	if parent.is_body_in:
		if restore_timer and restore_timer.is_inside_tree():
			restore_timer.start(retry_interval)
		return
	
	if is_instance_valid(affected_body):
		tilemap.set_cell(prev_tile_pos, 0, Vector2(0, 0))
		affected_body.stamp_component.remove_stamp(prev_global_pos)
		affected_body.stamp_component.locals_stamped.erase(prev_global_pos)
	
	parent.queue_free()
