extends TileMapLayer
class_name WorldTileMap

func get_snapped_position(global_pos : Vector2) -> Vector2i:
	var tile_coords := get_coords(global_pos)
	return Vector2i(get_tile_global_position(tile_coords).round())

func get_coords(global_pos : Vector2) -> Vector2i:
	# O pequeno deslocamento evita que um ponto exatamente na borda seja
	# interpretado como pertencente ao tile anterior.
	return local_to_map(to_local(global_pos + Vector2(0.5, 0.5)))

func get_collision_coords(global_pos : Vector2, collision_normal : Vector2) -> Vector2i:
	# A normal aponta para fora do collider. Entrar meio pixel no bloco torna a
	# escolha da célula estável mesmo quando a colisão cai exatamente na borda.
	var point_inside_tile := global_pos - collision_normal.normalized() * 0.5
	return local_to_map(to_local(point_inside_tile))

func get_tile_global_position(tile_coords : Vector2i) -> Vector2:
	var half_tile_size := Vector2(tile_set.tile_size) * 0.5
	return to_global(map_to_local(tile_coords) - half_tile_size)

func get_tile_global_center(tile_coords : Vector2i) -> Vector2:
	return to_global(map_to_local(tile_coords))
