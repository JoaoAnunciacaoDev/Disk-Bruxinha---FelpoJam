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
	if not body.is_package: return
	if body.carrier:
		if not body.carrier_updated.is_connected(_on_carrier_updated):
			body.carrier_updated.connect(_on_carrier_updated)
		return
	
	effect_delivery(body)

func effect_delivery(body : Node2D) -> void:
	if delivery_completed: return
	delivery_completed = true
	
	body.queue_free()
	
	SfxManager.play_sfx("recipient")
	
	if not anim_player.is_playing(): anim_player.play("delivery")

func _on_body_exited(body: Node2D) -> void:
	if body.carrier_updated.is_connected(_on_carrier_updated):
		body.carrier_updated.disconnect(_on_carrier_updated)

func _on_carrier_updated(has_carrier : bool, body : Node2D) -> void:
	if not has_carrier:
		effect_delivery(body)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if last_house: delivery_complete.emit()
	
	AchievementsManager.unlock("delivery")
	item_associated.show_item()
	item_associated.monitorable = true
	item_associated.monitoring = true
