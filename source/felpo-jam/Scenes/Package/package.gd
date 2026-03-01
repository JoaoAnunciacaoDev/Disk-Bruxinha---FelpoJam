extends CarryableObject
class_name Package

const PUSH_FORCE : float = 1500.0
const MIN_PUSH_FORCE : float = 10.0

@export var interaction_area : Area2D
@export var warning : Label
@export var is_package : bool = true

func _ready() -> void:
	state = States.Dropped

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	
	if state == States.Launched:
		for i in get_slide_collision_count():
			var c = get_slide_collision(i)
			var collider = c.get_collider()
			
			if collider is NPC:
				AchievementsManager.unlock("work_accident")
				var push_force : float = (PUSH_FORCE * velocity.length() / 100.0) + MIN_PUSH_FORCE
				var push_direction : Vector2 = -c.get_normal()
				var axis_used : float = push_direction.x if push_direction.x != 0.0 else push_direction.y
				collider.apply_torque_impulse(axis_used * push_force)

func _on_area_2d_body_entered(body: Node2D) -> void:
	warning.show()

func _on_area_2d_body_exited(body: Node2D) -> void:
	warning.hide()

func on_take_object() -> void:
	SfxManager.play_sfx("box")
	interaction_area.monitorable = false
	interaction_area.monitoring = false
	warning.hide()

func on_drop_object() -> void:
	interaction_area.monitorable = true
	interaction_area.monitoring = true
