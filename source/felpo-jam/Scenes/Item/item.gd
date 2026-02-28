extends Area2D
class_name Item

@export var sprite : Sprite2D

@export var item_id : String = ""
@export var item_quantity : int = 1
@export var item_icon : Texture2D

@export var message : Label

func _ready() -> void:
	sprite.texture = item_icon
	var tween : Tween = create_tween().set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.5).from(Vector2(0.0, 0.0))

func show_item() -> void:
	scale = Vector2(0.0, 0.0)
	show()
	var tween : Tween = create_tween().set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 1.0).from(Vector2(0.0, 0.0))

func _on_body_entered(body: Node2D) -> void:
	message.show()

func _on_body_exited(body: Node2D) -> void:
	message.hide()
