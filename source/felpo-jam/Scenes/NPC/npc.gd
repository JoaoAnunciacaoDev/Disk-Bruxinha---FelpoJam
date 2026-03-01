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

@export_category("Dialog Data")
@export var dialog_path : String
@export var dialog_resource : Dialog

@export_category("Quests Data")
@export var quests : Array[Quest] = []

var quest_manager : QuestManager = null

var current_state : String = "start"
var current_branch_index : int = 0
var player_in_area : bool = false

func _ready() -> void:
	sprite.texture = npc_texture
	quest_manager = player.quest_manager
	
	dialog_resource.load_from_json(dialog_path)

func _process(delta: float) -> void:
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

func _on_body_entered(body: Node2D) -> void:
	warning.show()
	player_in_area = true

func _on_body_exited(body: Node2D) -> void:
	warning.hide()
	message_box.hide_dialog()
	player_in_area = false

func _on_sleeping_state_changed() -> void:
	if sleeping:
		rotation = 0
		AchievementsManager.unlock("work_accident")

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
