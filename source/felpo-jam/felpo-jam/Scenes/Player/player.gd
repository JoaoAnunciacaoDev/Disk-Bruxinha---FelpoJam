extends CharacterBody2D
class_name Player

signal respawned

const REMOVE_STAMP_SCENE : PackedScene = preload("res://Scenes/Stamp/RemoveStamp/removing_stamp_area.tscn")

@export_category("Flags")
@export var is_dead : bool
@export var is_stamping : bool
@export var has_carryable : bool
@export var is_removing_stamp : bool
@export var was_on_floor : bool
@export var has_blue_stamp : bool = true
@export var has_orange_stamp : bool
@export var has_red_stamp : bool
@export var has_remover_stamp : bool
@export var can_move : bool = true
@export var show_crosshair : bool = true

@export_category("Node's Reference")
@export var quest_manager : QuestManager
@export var quest_tracker : QuestTracker
@export var all_body_sprite : Node2D
@export var stamping_pivot : Node2D
@export var ground_pivot : Node2D
@export var stamping_sprite : Sprite2D
@export var superior_sprite : Sprite2D
@export var inferior_sprite : Sprite2D
@export var body_collision : CollisionShape2D
@export var interaction_area : Area2D
@export var carry_position_marker : Marker2D
@export var camera : Camera2D
@export var up_check : RayCast2D
@export var down_check : RayCast2D
@export var anim_player : AnimationPlayer
@export var juice_player : AnimationPlayer
@export var state_machine : StateMachine
@export var world_tilemap : WorldTileMap

@export_category("Components Reference")
@export var move_component : MoveComponent
@export var jump_component : JumpComponent
@export var stamp_component : StampComponent

@export_category("Throw Data")
@export var max_throw_force : float = 400.0
@export var throw_force : float = 0.0
@export var throw_rate : float = 250.0
@export var progress_bar : ProgressBar

var last_save_position : Vector2

var carry_position : Vector2
var carrying_object : CarryableObject

var facing : int = 1

var selected_quest : Quest = null

func _ready() -> void:
	last_save_position = global_position
	
	stamp_component.crosshair.visible = show_crosshair
	
	quest_manager.quest_updated.connect(_on_quest_updated)
	quest_manager.objective_updated.connect(_on_objective_updated)

func _process(delta: float) -> void:
	if is_dead: return
	if not can_move: return
	
	state_machine.on_process(delta)

func _physics_process(delta: float) -> void:
	state_machine.on_physics_process(delta)
	if is_dead: return
	if not can_move: return
	
	carry_position = carry_position_marker.global_position
	
	throw_force_update(delta)
	
	check_squeezed()
	
	active_gravity(delta, jump_component.get_gravity())
	
	check_was_on_floor()
	
	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	if is_dead: return
	if not can_move: return
	
	state_machine.on_input(event)
	
	if event.is_action_pressed("remove_stamp") and has_remover_stamp: active_remove_stamp()
	if event.is_action_pressed("quest_tab"): quest_manager.show_hide_log()

func active_gravity(delta : float, accel : float) -> void:
	if is_stamping:
		jump_component.cut_velocity_y()
	elif not is_on_floor() and velocity.y <= jump_component.max_fall_speed:
		velocity.y += accel * delta

func check_was_on_floor() -> void:
	if was_on_floor and not is_on_floor() and velocity.y >= 0:
		jump_component.start_coyote_time()
	was_on_floor = is_on_floor()

func flip_sprite(input_axis : float) -> void:
	if not can_move: return
	
	if input_axis != 0 and not is_stamping:
		superior_sprite.flip_h = input_axis < 0
		inferior_sprite.flip_h = input_axis < 0
		facing = int(input_axis)
		
		stamping_pivot.scale.x = int(input_axis)
		ground_pivot.scale.x = int(input_axis)
		stamp_component.detect_ground_raycast.scale.x = int(input_axis)
		stamp_component.detect_wall_raycast.scale.x = int(input_axis)

func check_squeezed() -> void:
	if up_check.is_colliding() and down_check.is_colliding():
		is_dead = true

func active_remove_stamp() -> void:
	if is_removing_stamp: return
	is_removing_stamp = true
	
	var remove_stamp_instance : RemoveStamp = REMOVE_STAMP_SCENE.instantiate()
	remove_stamp_instance.global_position = global_position
	remove_stamp_instance.remove_finished.connect(_on_removed_stamp)
	get_tree().root.add_child(remove_stamp_instance)

func _on_removed_stamp(positions_list : Array[Vector2i]) -> void:
	is_removing_stamp = false
	
	for pos in positions_list:
		stamp_component.remove_stamp(pos)

func throw_force_update(delta : float) -> void:
	if Input.is_action_pressed("throw") and has_carryable:
		throw_force = min(max_throw_force, throw_force + (delta * throw_rate))
		progress_bar.show()
		progress_bar.value = throw_force
	else:
		progress_bar.hide()
		progress_bar.value = 0.0

func handle_interact_object() -> void:
	if carrying_object:
		if Input.is_action_just_released("throw"):
			
			carrying_object.on_drop_object()
			carrying_object.last_direction = facing
			carrying_object.state = carrying_object.States.Launched
			carrying_object.throw_velocity = Vector2(throw_force, -throw_force)
			carrying_object.warning.show()
			
			if velocity == Vector2.ZERO:
				carrying_object.velocity = carrying_object.throw_velocity * Vector2(facing, 1)
			else:
				carrying_object.velocity = (velocity * 0.25) + carrying_object.throw_velocity * Vector2(facing, 1)
			
			throw_force = 0.0
			
			carrying_object.carrier = null
			carrying_object = null
			has_carryable = false
		elif can_move:
			var bodies : Array[Node2D] = interaction_area.get_overlapping_bodies()
			if bodies.size() > 0:
				for body in bodies:
					if body is NPC:
						if Input.is_action_just_pressed("interact"):
							
							can_move = false
							body.start_dialog()
							check_quest_objectives(body.npc_id, "talk_to")
							body.on_over_dialog.connect(func(): can_move = true)
		
	else:
		
		var bodies : Array[Node2D] = interaction_area.get_overlapping_bodies()
		var areas : Array[Area2D] = interaction_area.get_overlapping_areas()
		
		if bodies.size() > 0:
			for body in bodies:
				if body is CarryableObject and (body.state == body.States.Pickupable or body.state == body.States.Launched):
					if Input.is_action_just_pressed("interact"):
						
						carrying_object = body
						body.carrier = self
						body.global_position = carry_position
						body.state = body.States.Carry
						body.warning.hide()
						has_carryable = true
						carrying_object.on_take_object()
						break
						
				elif body is NPC:
					if can_move:
						if Input.is_action_just_pressed("interact"):
							
							can_move = false
							body.start_dialog()
							check_quest_objectives(body.npc_id, "talk_to")
							body.on_over_dialog.connect(func(): can_move = true)
							break
				
		elif areas.size() > 0:
			for area in areas:
				if area is Item:
					if Input.is_action_just_pressed("interact"):
						if is_item_needed(area.item_id):
							check_quest_objectives(area.item_id, "collection", area.item_quantity)
							area.queue_free()
							break

func drop_carried_object() -> void:
	if carrying_object:
		carrying_object.on_drop_object()
		carrying_object.velocity = Vector2.ZERO
		carrying_object.state = carrying_object.States.Dropped
		carrying_object.carrier = null
		carrying_object = null

func is_item_needed(item_id : String) -> bool:
	if selected_quest != null:
		for objective in selected_quest.objectives:
			print("Objetivo bate com o item? ", objective.target_id == item_id)
			print("Item id: ", item_id)
			print("Target id: ", objective.target_id)
			print("É colecionável? ", objective.target_type == "collection")
			print("Está completo? ", objective.is_completed)
			if objective.target_id == item_id and objective.target_type == "collection" and not objective.is_completed:
				print("BAeu ceertinohfiosdfasdoah")
				return true
	return false

func check_quest_objectives(target_id : String, target_type : String, quantity : int = 1) -> void:
	print("Selected_quest: ", selected_quest)
	
	if selected_quest == null: return
	
	var objective_updated : bool = false
	
	for objective in selected_quest.objectives:
		if objective.target_id == target_id and objective.target_type == target_type and not objective.is_completed:
			selected_quest.complete_objective(objective.id, quantity)
			objective_updated = true
			break
	print("É do objetivo? ", objective_updated)
	print("Objective_updated: ", objective_updated)
	if objective_updated:
		if selected_quest.is_completed():
			handle_quest_completion(selected_quest)
		
		update_quest_tracker(selected_quest)

func handle_quest_completion(quest : Quest) -> void:
	for reward in quest.rewards:
		print(reward)
		if reward.reward_type == "blue_stamp":
			has_blue_stamp = true
		elif reward.reward_type == "orange_stamp":
			has_orange_stamp = true
		elif reward.reward_type == "red_stamp":
			has_red_stamp = true
		elif reward.reward_type == "remover_stamp":
			has_remover_stamp = true
	
	update_quest_tracker(quest)
	quest_manager.update_quest(quest.quest_id, "completed")

func update_quest_tracker(quest : Quest) -> void:
	if quest:
		quest_tracker.show()
		quest_tracker.quest_title.text = quest.quest_name
		
		for child in quest_tracker.objectives.get_children():
			quest_tracker.objectives.remove_child(child)
			child.queue_free()
		
		for objective in quest.objectives:
			var label : Label = Label.new()
			label.text = objective.description
			
			if objective.is_completed:
				label.add_theme_color_override("font_color", Color(0, 1, 0))
			else:
				label.add_theme_color_override("font_color", Color(1, 0, 0))
			
			quest_tracker.objectives.add_child(label)
	else:
		quest_tracker.hide()

func _on_quest_updated(quest_id : String) -> void:
	var quest : Quest = quest_manager.get_quest(quest_id)
	
	if quest == selected_quest:
		update_quest_tracker(quest)
	
	selected_quest = null

func _on_objective_updated(quest_id : String, objective_id : String) -> void:
	if selected_quest and selected_quest.quest_id == quest_id:
		update_quest_tracker(selected_quest)
	
	selected_quest = null

func die() -> void:
	body_collision.disabled = true
	anim_player.play("die")
	
	var tween : Tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "global_position", last_save_position, 1.0)
	tween.finished.connect(func(): 
		is_dead = false
		body_collision.disabled = false
		respawned.emit()
		print("Respawnou")
		)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "stamp_ground" or anim_name == "stamp_wall":
		stamp_component._on_stamp_finished.emit()

func _on_juice_animation_animation_finished(anim_name: StringName) -> void:
	if anim_name == "squash" and state_machine.current_state.name == "jump":
		juice_player.play("stretch")
