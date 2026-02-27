extends CanvasLayer
class_name TransitionScene

signal transition_over(transition_name : String)

@export var anim_player : AnimationPlayer

func play_fade_in() -> void:
	anim_player.play("fade_in")

func play_fade_out() -> void:
	anim_player.play("fade_out")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	emit_signal("transition_over", anim_name)
