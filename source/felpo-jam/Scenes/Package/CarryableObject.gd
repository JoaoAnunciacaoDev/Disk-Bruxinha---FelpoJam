extends CharacterBody2D
class_name CarryableObject

enum States {
	Dropped,
	Pickupable,
	Carry,
	Launched
}

@export var throw_velocity : Vector2
var carrier : Player
var carry_position : Vector2
var gravity : Vector2 = Vector2(0, 700)

var state : States

func _physics_process(delta: float) -> void:
	if carrier:
		carry_position = carrier.carry_position
	
	match state:
		States.Carry:
			global_position = carry_position
			
		States.Dropped:
			velocity.y += delta * gravity.y
			
			if is_on_floor():
				velocity = Vector2.ZERO
				state = States.Pickupable
			
		States.Launched:
			velocity.y += delta * gravity.y
			if velocity.y >= 0:
				state = States.Dropped
			
		_:
			velocity = Vector2.ZERO
		
	move_and_slide()

func show_interaction_action() -> void:
	pass
