extends PanelContainer

signal time_screen_over(cell : PanelContainer)

@export var icon : TextureRect
@export var title_label : Label
@export var description_label : Label
@export var unlock_label : Label
@export_range(1.0, 10.0, 0.25) var notification_duration : float = 4.0

var is_notification : bool = false

func setup(achievement: Achievement, is_unlocked: bool, notification := false) -> void:
	is_notification = notification
	unlock_label.visible = is_notification

	if is_unlocked:
		icon.texture = achievement.unlockedIcon
		title_label.text = tr(achievement.achievementName)
	else:
		icon.texture = achievement.lockedIcon
		title_label.text = "???"
	
	description_label.text = tr(achievement.description)

func _ready() -> void:
	unlock_label.visible = is_notification
	if not is_notification:
		scale = Vector2.ONE
		modulate.a = 1.0
		return

	await get_tree().process_frame
	pivot_offset = Vector2(size.x, size.y * 0.5)
	scale = Vector2(0.78, 0.78)
	modulate.a = 0.0

	var entrance_tween := create_tween().set_parallel(true)
	entrance_tween.tween_property(self, "scale", Vector2.ONE, 0.32) \
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	entrance_tween.tween_property(self, "modulate:a", 1.0, 0.16) \
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	await entrance_tween.finished

	await get_tree().create_timer(notification_duration, true, false, true).timeout
	time_screen_over.emit(self)
