extends RayCast2D

@export var max_length : float = 32.0
@export var is_detecting_ground : bool

func _ready() -> void:
	_update_target_position()

func _physics_process(_delta: float) -> void:
	if is_detecting_ground:
		if Input.is_action_pressed("down"):
			position.x = 0.0
		else:
			position.x = 32.0

func _update_target_position() -> void:
	if is_detecting_ground:
		target_position = Vector2(0.0, max_length)
	else:
		target_position = Vector2(max_length, 0.0)
