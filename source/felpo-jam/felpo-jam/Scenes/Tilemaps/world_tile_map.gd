extends TileMapLayer
class_name WorldTileMap

func get_snapped_position(global_pos : Vector2) -> Vector2i:
	var local_pos : Vector2i = local_to_map(global_pos)
	var tile_pos : Vector2 = map_to_local(local_pos) - Vector2(16, 16)
	#print("Global position: ", global_pos)
	#print("local position: ", local_pos)
	#print("Tile position", tile_pos)
	return tile_pos

func get_coords(global_pos : Vector2) -> Vector2i:
	var tile_coords = local_to_map(to_local(global_pos))
	return tile_coords
