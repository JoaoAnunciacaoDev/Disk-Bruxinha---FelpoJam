extends Control
class_name QuestUI

@export_category("Node's Reference")
@export var quest_manager : QuestManager
@export var panel : PanelContainer
@export var quest_list : VBoxContainer
@export var quest_title : Label
@export var quest_description : Label
@export var quest_objectives : VBoxContainer
@export var quest_rewards : VBoxContainer

var selected_quest : Quest = null

func _ready() -> void:
	panel.hide()
	clear_quest_details()
	
	quest_manager.quest_updated.connect(_on_quest_updated)
	quest_manager.objective_updated.connect(_on_objective_updated)

func show_hide_log() -> void:
	panel.visible = not panel.visible
	update_quest_list()
	
	if selected_quest:
		_on_quest_selected(selected_quest)

func update_quest_list() -> void:
	for child in quest_list.get_children():
		quest_list.remove_child(child)
		child.queue_free()
	
	var active_quests : Array[Quest] = quest_manager.get_active_quests()
	if active_quests.size() == 0:
		clear_quest_details()
		quest_manager.player.selected_quest = null
		quest_manager.player.update_quest_tracker(null)
	else:
		for quest in active_quests:
			var button : Button = Button.new()
			button.add_theme_font_size_override("font_size", 12)
			button.text = quest.quest_name
			button.pressed.connect(_on_quest_selected.bind(quest))
			
			quest_list.add_child(button)
	
	quest_manager.player.update_quest_tracker(selected_quest)

func _on_quest_selected(quest : Quest) -> void:
	selected_quest = quest
	quest_manager.player.selected_quest = quest
	
	quest_title.text = quest.quest_name
	quest_description.text = quest.quest_description
	
	for child in quest_objectives.get_children():
		quest_objectives.remove_child(child)
		child.queue_free()
	
	for objective in quest.objectives:
		var label : Label = Label.new()
		label.add_theme_font_size_override("font_size", 12)
		
		if objective.target_type == "collection":
			label.text = objective.description + "(" + str(objective.collected_quantity) + "/" + str(objective.required_quantity) + ")"
		else:
			label.text = objective.description
		
		if objective.is_completed:
			label.add_theme_color_override("font_color", Color(0, 1, 0))
		else:
			label.add_theme_color_override("font_color", Color(1, 0, 0))
		
		quest_objectives.add_child(label)
	
	for child in quest_rewards.get_children():
		quest_rewards.remove_child(child)
		child.queue_free()
	
	for reward in quest.rewards:
		var label : Label = Label.new()
		label.add_theme_font_size_override("font_size", 12)
		label.add_theme_color_override("font_color", Color(0, 0.84, 0))
		label.text = "Recompensas: " + reward.reward_type.capitalize() + ": " + str(reward.reward_amount)
		quest_rewards.add_child(label)

func clear_quest_details() -> void:
	quest_title.text = ""
	quest_description.text = ""
	
	for child in quest_objectives.get_children():
		quest_objectives.remove_child(child)
		child.queue_free()
	
	for child in quest_rewards.get_children():
		quest_rewards.remove_child(child)
		child.queue_free()

func _on_quest_updated(quest_id : String) -> void:
	if selected_quest and selected_quest.quest_id == quest_id:
		_on_quest_selected(selected_quest)
	else:
		update_quest_list()
	
	selected_quest = null
	quest_manager.player.selected_quest = null

func _on_objective_updated(quest_id : String) -> void:
	if selected_quest and selected_quest.quest_id == quest_id:
		_on_quest_selected(selected_quest)
	else:
		clear_quest_details()
	
	selected_quest = null
	quest_manager.player.selected_quest = null
