extends Control
class_name HoverClass

func _ready():
	pivot_offset = size / 2
	resized.connect(func(): pivot_offset = size / 2)
	
	mouse_entered.connect(_on_hover_enter)
	mouse_exited.connect(_on_hover_exit)

func _on_hover_enter():
	SfxManager.play_sfx("bip")
	
	z_index = 1 
	
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector2(1.1, 1.1), 0.2)

func _on_hover_exit():
	z_index = 0
	
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.2)
