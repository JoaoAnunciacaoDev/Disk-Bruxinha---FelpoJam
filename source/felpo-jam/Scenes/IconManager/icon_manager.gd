extends Node2D
class_name IconManager

@export_category("Icon Settings")
@export var icon_spacing : int = 10
@export var padding_y_offset : int = -10
@export var icons : Dictionary[String, Texture2D] = {}
@export var blue_container : Node2D
@export var orange_container : Node2D
@export var blue_marker : Marker2D
@export var orange_marker : Marker2D

func _process(_delta: float) -> void:
	_update_card_targets()

func add_icon(icon_name : String) -> void:
	var new_sprite : Sprite2D = Sprite2D.new()
	new_sprite.texture = icons[icon_name]
	
	if icon_name == "Carimbo Azul":
		var blue_list : Array = blue_container.get_children()
		if blue_list.size() == 4: return
		new_sprite.position = _calculate_position(blue_list.size() - 1, blue_container.get_children(), blue_marker)
		blue_container.add_child(new_sprite)
	else:
		var orange_list : Array = orange_container.get_children()
		if orange_list.size() == 4: return
		new_sprite.position = _calculate_position(orange_list.size() - 1, orange_container.get_children(), orange_marker)
		orange_container.add_child(new_sprite)

func remove_icon(icon_name : String) -> void:
	if icon_name == "Carimbo Azul":
		var blue_list : Array = blue_container.get_children()
		if not blue_list.is_empty():
			var icon = blue_list.pop_back()
			icon.queue_free()
	else:
		var orange_list : Array = orange_container.get_children()
		if not orange_list.is_empty():
			var icon = orange_list.pop_back()
			icon.queue_free()

func remove_all_icon(icon_name : String) -> void:
	if icon_name == "Carimbo Azul":
		var blue_list : Array = blue_container.get_children()
		for element in blue_list:
			element.queue_free()
	else:
		var orange_list : Array = orange_container.get_children()
		for element in orange_list:
			element.queue_free()

func _calculate_position(index: int, container : Array, marker : Marker2D) -> Vector2:
	
	var start_x = marker.position.x
	var pos_y = marker.position.y + padding_y_offset
	
	return Vector2(start_x + (index * icon_spacing), pos_y)

func _update_card_targets() -> void:
	var blue_list : Array = blue_container.get_children()
	
	for i in range(blue_list.size()):
		var icon = blue_list[i]
	
	var orange_list : Array = orange_container.get_children()
	
	for i in range(orange_list.size()):
		var icon = orange_list[i]
