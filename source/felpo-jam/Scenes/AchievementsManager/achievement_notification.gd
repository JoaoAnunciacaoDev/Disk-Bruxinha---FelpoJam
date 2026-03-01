extends CanvasLayer

const ACHIEVEMENT_CELL : PackedScene = preload("res://Scenes/AchievementsManager/achievement_cell.tscn")

@export var vbox : VBoxContainer

func _ready() -> void:
	AchievementsManager.achievement_unlocked.connect(_on_achievement_unlocked)
	hide()

func _on_achievement_unlocked(achievement_data : Achievement) -> void:
	show()
	var cell_instance : PanelContainer = ACHIEVEMENT_CELL.instantiate()
	cell_instance.setup(achievement_data, true)
	cell_instance.connect("time_screen_over", _on_cell_timer_over)
	vbox.add_child(cell_instance)
	SfxManager.play_sfx("objectiveItem")

func _on_cell_timer_over(cell : PanelContainer) -> void:
	var tween : Tween = create_tween()
	tween.tween_property(cell, "modulate:a", 0.0, 1.0)
	await tween.finished
	cell.queue_free()
	
	if vbox.get_children().size() == 0:
		vbox.hide()
