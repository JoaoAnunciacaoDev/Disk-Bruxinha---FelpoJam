extends CanvasLayer

@export var title_label : Label
@export var desc_label : Label
@export var texture : TextureRect

@export_category("Tutorial Data")
@export var item_name : String
@export var item_texture : Dictionary[String, Texture2D] = {"Carimbo Azul": preload("res://Assets/Stamps/speed_stamp_tutorial.png"),
															"Carimbo Laranja": preload("res://Assets/Stamps/jump_stamp_tutorial.png"),
															"Carimbo Vermelho": preload("res://Assets/Stamps/break_stamp_tutorial.png")}

@export var item_keys : Dictionary[String, Texture2D] = {"Carimbo Azul": preload("res://Assets/J_Key.png"),
															"Carimbo Laranja": preload("res://Assets/k_kEY.png"),
															"Carimbo Vermelho": preload("res://Assets/l_kEY.png")}

@export var item_buttons : Dictionary[String, Texture2D] = {"Carimbo Azul": preload("res://Assets/x_bUTTON.png"),
															"Carimbo Laranja": preload("res://Assets/y_bUTTON.png"),
															"Carimbo Vermelho": preload("res://Assets/b_bUTTON.png")}

func show_tutorial() -> void:
	
