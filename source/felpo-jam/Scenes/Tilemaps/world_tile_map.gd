extends TileMapLayer
class_name WorldTileMap

@export var blocks_data : Dictionary[String, BlockData]

func get_snapped_position(global_pos : Vector2) -> Vector2i:
	var tile_pos : Vector2 = map_to_local(local_to_map(global_pos)) + Vector2(-16, 16)
	print(global_pos)
	print(tile_pos)
	return tile_pos

func get_coords(global_pos : Vector2) -> Vector2i:
	var tile_coords = local_to_map(to_local(global_pos)) + Vector2i(0, 1)
	return tile_coords
