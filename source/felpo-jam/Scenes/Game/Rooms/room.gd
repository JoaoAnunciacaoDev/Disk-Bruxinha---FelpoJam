extends Node2D
class_name Room

@export var world_tilemap : WorldTileMap
@export var player : Player

func _ready() -> void:
	player.world_tilemap = world_tilemap
