extends Area2D
class_name RemoveStamp

signal remove_finished(positions_list : Array[Vector2i])

@export var sprite : Sprite2D
@export var collision : CollisionShape2D

@export var initial_radius : float = 2.0
@export var initial_scale : float = 0.2
@export var final_radius : float = 64.0
@export var final_scale : float = 3.9
@export var duration : float = 1.0

var positions_list : Array[Vector2i]

func _ready() -> void:
	collision.shape.radius = 2.0
	sprite.scale = Vector2(initial_scale, initial_scale)
	
	var tween : Tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.set_parallel(true)
	tween.tween_property(sprite, "scale", Vector2(final_scale, final_scale), duration)
	tween.tween_property(collision, "shape:radius", final_radius, duration)
	
	tween.finished.connect(func(): 
		remove_finished.emit(positions_list)
		queue_free())

func _on_area_entered(area: Area2D) -> void:
	var stamp : StampInstance = area.get_parent()
	positions_list.append(stamp.stamp_pos)
