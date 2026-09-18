extends CarryableObject
class_name Package

@export var interaction_area : Area2D
@export var warning : Label
@export var is_package : bool = true

func _ready() -> void:
	state = States.Dropped

func on_launched_collision(collision : KinematicCollision2D, impact_velocity : Vector2) -> void:
	var collider := collision.get_collider()
	if collider is NPC:
		AchievementsManager.unlock("work_accident")
		collider.receive_impact(impact_velocity, collision.get_normal())

func _on_area_2d_body_entered(_body: Node2D) -> void:
	warning.show()

func _on_area_2d_body_exited(_body: Node2D) -> void:
	warning.hide()

func on_take_object() -> void:
	SfxManager.play_sfx("box")
	interaction_area.monitorable = false
	interaction_area.monitoring = false
	warning.hide()

func on_drop_object() -> void:
	interaction_area.monitorable = true
	interaction_area.monitoring = true
