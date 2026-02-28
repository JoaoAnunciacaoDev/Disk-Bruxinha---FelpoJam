extends Control
class_name MessageDisplay

signal on_over_dialog

@export var dialog_manager : DialogManager
@export var panel : PanelContainer
@export var name_label : Label
@export var text_label : Label
@export var dialog_options : HBoxContainer
@export var is_npc : bool = true

func _ready() -> void:
	if not is_npc:
		text_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	
	pivot_offset = size / 2
	resized.connect(func(): pivot_offset = size / 2)
	
	
	name_label.hide()
	dialog_options.hide()
	panel.hide()
	hide()

func set_message(text : String) -> void:
	text_label.text = text
	show()

func show_dialog(speaker : String, text : String, options : Dictionary) -> void:
	panel.show()
	name_label.show()
	dialog_options.show()
	
	name_label.text = speaker
	text_label.text = text
	
	for option in dialog_options.get_children():
		dialog_options.remove_child(option)
		option.queue_free()
	
	for option in options.keys():
		var button : Button = Button.new()
		button.text = option
		button.add_theme_font_size_override("font_size", 12)
		button.pressed.connect(_on_option_selected.bind(option))
		dialog_options.add_child(button)

func hide_dialog() -> void:
	dialog_manager.npc.player.can_move = true
	name_label.hide()
	dialog_options.hide()
	panel.hide()
	on_over_dialog.emit()

func _on_option_selected(option : String) -> void:
	dialog_manager.handle_dialog_choice(option)
