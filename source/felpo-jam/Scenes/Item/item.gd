extends Area2D
class_name Item

@export var sprite : Sprite2D

@export var item_id : String = ""
@export var item_quantity : int = 1
@export var item_icon : Texture2D

@export var message : MessageDisplay

func _ready() -> void:
	sprite.texture = item_icon

func _on_body_entered(body: Node2D) -> void:
	message.set_message("!")

func _on_body_exited(body: Node2D) -> void:
	message.hide()
