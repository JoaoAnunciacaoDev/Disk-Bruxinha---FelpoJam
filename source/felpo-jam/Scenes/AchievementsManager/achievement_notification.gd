extends CanvasLayer

const ACHIEVEMENT_CELL : PackedScene = preload("res://Scenes/AchievementsManager/achievement_cell.tscn")

@export var vbox : VBoxContainer

var pending_notifications : Array[Achievement] = []
var is_showing_notification : bool = false

func _ready() -> void:
	AchievementsManager.achievement_unlocked.connect(_on_achievement_unlocked)
	vbox.hide()
	hide()

func _on_achievement_unlocked(achievement_data : Achievement) -> void:
	show_preview(achievement_data)

func show_preview(achievement_data : Achievement) -> void:
	# Também é usado pela cena de testes. Apenas exibe a notificação e não
	# altera o progresso salvo pelo AchievementsManager.
	pending_notifications.append(achievement_data)
	if not is_showing_notification:
		_show_next_notification()

func _show_next_notification() -> void:
	if pending_notifications.is_empty():
		is_showing_notification = false
		vbox.hide()
		hide()
		return

	is_showing_notification = true
	show()
	vbox.show()

	var achievement_data : Achievement = pending_notifications.pop_front()
	var cell_instance : PanelContainer = ACHIEVEMENT_CELL.instantiate()
	cell_instance.setup(achievement_data, true, true)
	cell_instance.connect("time_screen_over", _on_cell_timer_over)
	vbox.add_child(cell_instance)
	SfxManager.play_sfx("objectiveItem")

func _on_cell_timer_over(cell : PanelContainer) -> void:
	var tween := create_tween().set_parallel(true)
	tween.tween_property(cell, "modulate:a", 0.0, 0.18) \
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	tween.tween_property(cell, "scale", Vector2(0.88, 0.88), 0.2) \
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	await tween.finished
	cell.queue_free()
	_show_next_notification()
