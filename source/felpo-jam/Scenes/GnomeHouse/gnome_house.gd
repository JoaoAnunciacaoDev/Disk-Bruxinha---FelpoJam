extends Area2D

signal delivery_complete()

@export var item_associated : Item
@export var anim_player : AnimationPlayer
@export var last_house : bool

var delivery_completed : bool = false

func _ready() -> void:
	item_associated.hide()
	item_associated.monitorable = false
	item_associated.monitoring = false

func _on_body_entered(body: Node2D) -> void:
	if body.carrier: return
	
	if delivery_completed: return
	delivery_completed = true
	
	body.queue_free()
	
	if not anim_player.is_playing(): anim_player.play("delivery")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if last_house: delivery_complete.emit()
	
	item_associated.show()
	item_associated.monitorable = true
	item_associated.monitoring = true
