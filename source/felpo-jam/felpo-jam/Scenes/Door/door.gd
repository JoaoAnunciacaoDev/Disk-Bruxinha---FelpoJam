extends StaticBody2D
class_name Door

@export var pressure_plate : Array[PressurePlate]
@export var anim_player : AnimationPlayer
@export var speed_scale : float = 0.15
@export var pressure_plates_needed : int = 1

var pressure_plate_counter : int = 0
var is_open : bool = false

func _ready() -> void:
	for plate in pressure_plate:
		plate.is_pressed.connect(_on_active_door)
	
	

func _on_active_door(is_active : bool) -> void:
	match is_active:
		true:
			pressure_plate_counter = min(pressure_plates_needed, pressure_plate_counter + 1)
		false:
			pressure_plate_counter = max(0, pressure_plate_counter - 1)
	print("tá aberto? ", is_open)
	if pressure_plate_counter == pressure_plates_needed and not is_open:
		is_open = true
		anim_player.speed_scale = 1.0
		anim_player.queue("open")
	elif pressure_plate_counter != pressure_plates_needed and is_open:
		is_open = false
		anim_player.speed_scale = speed_scale
		anim_player.queue("close")
	
	print("Contador: ", pressure_plate_counter, " De ", pressure_plates_needed)
	print(pressure_plate_counter == pressure_plates_needed)
	
