extends RigidBody2D
class_name NPC

signal on_over_dialog

@export_category("Node's Reference")
@export var player : Player
@export var sprite : Sprite2D

@export_category("NPC Data")
@export var npc_name : String
@export var npc_id : String
@export var quotes : Dictionary[String, String]
@export var dialog_manager : DialogManager
@export var message_box : MessageDisplay
@export var warning : Label
@export var npc_texture : Texture2D

@export_category("Impact Reaction")
@export var max_wobble_degrees : float = 18.0
@export var reference_impact_speed : float = 400.0

@export_category("Dialog Data")
@export var dialog_path : String
@export var dialog_resource : Dialog

@export_category("Quests Data")
@export var quests : Array[Quest] = []

var quest_manager : QuestManager = null

var current_state : String = "start"
var current_branch_index : int = 0
var player_in_area : bool = false
var sprite_rest_position : Vector2
var wobble_tween : Tween

func _ready() -> void:
	sprite.texture = npc_texture
	sprite_rest_position = sprite.position
	quest_manager = player.quest_manager
	
	dialog_resource.load_from_json(dialog_path)

func _process(_delta: float) -> void:
	if player_in_area: sprite.flip_h = player.position.x < position.x

func start_dialog() -> void:
	
	warning.hide()
	
	var npc_dialogs : Array = dialog_resource.get_npc_dialog(npc_id)
	if npc_dialogs.is_empty():
		print("Dialogs is empty")
		return
	
	dialog_manager.show_dialog(self)
	
func get_current_dialog():
	var npc_dialogs : Array = dialog_resource.get_npc_dialog(npc_id)
	if current_branch_index < npc_dialogs.size():
		for dialog in npc_dialogs[current_branch_index]["dialogs"]:
			if dialog["state"] == current_state:
				return dialog
	
	return null

func set_dialog_branch(branch_index : int) -> void:
	current_branch_index = branch_index
	current_state = "start"

func set_dialog_state(state : String) -> void:
	current_state = state

func _on_body_entered(_body: Node2D) -> void:
	warning.show()
	player_in_area = true

func _on_body_exited(_body: Node2D) -> void:
	warning.hide()
	message_box.hide_dialog()
	player_in_area = false

func _on_sleeping_state_changed() -> void:
	if sleeping:
		rotation = 0

func receive_impact(impact_velocity : Vector2, collision_normal : Vector2) -> void:
	var direction := signf(impact_velocity.x)
	if is_zero_approx(direction):
		direction = -signf(collision_normal.x)
	if is_zero_approx(direction):
		direction = 1.0

	var strength := clampf(impact_velocity.length() / maxf(reference_impact_speed, 1.0), 0.25, 1.0)
	var target_angle := deg_to_rad(max_wobble_degrees) * direction * strength

	if wobble_tween and wobble_tween.is_valid():
		wobble_tween.kill()

	wobble_tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	wobble_tween.tween_method(_set_wobble_angle, sprite.rotation, target_angle, 0.10)
	wobble_tween.tween_method(_set_wobble_angle, target_angle, -target_angle * 0.60, 0.16)
	wobble_tween.tween_method(_set_wobble_angle, -target_angle * 0.60, target_angle * 0.30, 0.14)
	wobble_tween.tween_method(_set_wobble_angle, target_angle * 0.30, 0.0, 0.18)

func _set_wobble_angle(angle : float) -> void:
	sprite.rotation = angle
	sprite.position = sprite_rest_position.rotated(angle)

func _on_message_on_over_dialog() -> void:
	on_over_dialog.emit()

func offer_quest(quest_id : String) -> void:
	for quest in quests:
		if quest.quest_id == quest_id and quest.state == "not_started":
			quest.state = "in_progress"
			quest_manager.add_quest(quest)
			return

func get_quest_dialog() -> Dictionary:
	var active_quests : Array[Quest] = quest_manager.get_active_quests()
	var first_objective_was_completed : bool = false
	
	for quest in active_quests:
		for objective in quest.objectives:
			if objective.is_first_objective: first_objective_was_completed = objective.is_completed
			
			if objective.is_first_objective or first_objective_was_completed:
				if objective.target_id == npc_id and objective.target_type == "talk_to" and not objective.is_completed:
					if current_state == "start":
						return {"text": objective.objective_dialog, "options": {"Ok": "exit"}}
		
	return {"text": "", "options": {}}
