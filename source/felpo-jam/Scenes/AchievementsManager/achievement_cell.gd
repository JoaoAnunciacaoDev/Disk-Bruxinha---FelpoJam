extends PanelContainer

signal time_screen_over(cell : PanelContainer)

@export var icon : TextureRect
@export var title_label : Label
@export var description_label : Label

func setup(achievement: Achievement, is_unlocked: bool):
	if is_unlocked:
		icon.texture = achievement.unlockedIcon
		title_label.text = tr(achievement.achievementName)
	else:
		icon.texture = achievement.lockedIcon
		title_label.text = "???"
	
	description_label.text = tr(achievement.description)

func _ready() -> void:
	var tween : Tween = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.5).from(Vector2(0.0, 0.0))
	
	await get_tree().create_timer(5.0).timeout
	emit_signal("time_screen_over", self)
