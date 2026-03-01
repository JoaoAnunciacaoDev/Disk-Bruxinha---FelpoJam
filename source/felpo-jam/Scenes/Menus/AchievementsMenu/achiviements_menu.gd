extends Control

signal back_pressed

const CONFIRM_STAMP = preload("res://Assets/SeloConfirmação.png")
const ACHIEVEMENT_CELL = preload("res://Scenes/AchievementsManager/achievement_cell.tscn")

@export var achievements_container : VBoxContainer
@export var back_button : TextureButton

func _ready() -> void:
	populate_list()

func populate_list():
	for child in achievements_container.get_children():
		child.queue_free()

	var all_achievements = AchievementsManager.all_achievements.values()
	
	for achievement in all_achievements:
		var entry = ACHIEVEMENT_CELL.instantiate()
		var is_unlocked = AchievementsManager.is_unlocked(achievement.id)
		entry.setup(achievement, is_unlocked)
		achievements_container.add_child(entry)

func on_visible() -> void:
	back_button.set_texture_focused(CONFIRM_STAMP)
	back_button.grab_focus()
	show()

func _on_back_pressed() -> void:
	back_pressed.emit()
	hide()
	SfxManager.play_sfx("button_pressed")
