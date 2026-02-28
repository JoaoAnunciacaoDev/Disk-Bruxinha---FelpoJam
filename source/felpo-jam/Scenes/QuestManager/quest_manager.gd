extends Node2D
class_name QuestManager

signal quest_updated(quest_id : String)
signal objective_updated(quest_id : String, objective_id : String)
signal quest_list_updated

@export var player : Player
@export var quest_ui : QuestUI

var quests : Dictionary[String, Quest] = {}

func add_quest(quest : Quest) -> void:
	quests[quest.quest_id] = quest
	quest_ui._on_quest_selected(quest)
	player.update_quest_tracker(quest)
	quest_updated.emit(quest.quest_id)

func remove_quest(quest_id : String) -> void:
	quests.erase(quest_id)
	quest_list_updated.emit()

func get_quest(quest_id : String) -> Quest:
	return quests.get(quest_id, null)

func update_quest(quest_id : String, state : String) -> void:
	var quest : Quest = get_quest(quest_id)
	if quest:
		quest.state = state
		quest_updated.emit(quest_id)
		
		if state == "completed":
			remove_quest(quest_id)

func get_active_quests() -> Array[Quest]:
	var active_quests : Array[Quest] = []
	
	for quest in quests.values():
		if quest.state == "in_progress":
			active_quests.append(quest)
	
	return active_quests

func complete_objective(quest_id : String, objective_id : String) -> void:
	var quest : Quest = get_quest(quest_id)
	if quest:
		quest.complete_objective(objective_id)
		objective_updated.emit(quest_id, objective_id)

func show_hide_log() -> void:
	quest_ui.show_hide_log()
