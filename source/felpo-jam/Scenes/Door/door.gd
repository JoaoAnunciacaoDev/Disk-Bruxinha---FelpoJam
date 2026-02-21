extends StaticBody2D
class_name Door

@export var pressure_plate : PressurePlate
@export var anim_player : AnimationPlayer

var is_open : bool = false

func _ready() -> void:
	pressure_plate.is_pressed.connect(_on_active_door)

func _on_active_door(is_active : bool) -> void:
	is_open = is_active
	
	match is_active:
		true:
			anim_player.queue("open")
		false:
			anim_player.queue("close")
