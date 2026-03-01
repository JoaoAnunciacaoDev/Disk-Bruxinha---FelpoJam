extends CanvasLayer

@export var background : ColorRect
@export var title_label : Label
@export var desc_label : Label
@export var texture : TextureRect
@export var key : TextureRect
@export var button : TextureRect
@export var confirm_button : Button

@export_category("Tutorial Data")
@export var item_texture : Dictionary[String, Texture2D] = {"Carimbo Azul": preload("res://Assets/Stamps/speed_stamp_tutorial.png"),
															"Carimbo Laranja": preload("res://Assets/Stamps/jump_stamp_tutorial.png"),
															"Carimbo Frágil": preload("res://Assets/Stamps/break_stamp_tutorial.png"),
															"Removedor de Carimbo": preload("res://Assets/Stamps/remover_stamp_tutorial.png")}

@export var item_keys : Dictionary[String, Texture2D] = {"Carimbo Azul": preload("res://Assets/J_Key.png"),
															"Carimbo Laranja": preload("res://Assets/k_kEY.png"),
															"Carimbo Frágil": preload("res://Assets/l_kEY.png"),
															"Removedor de Carimbo": preload("res://Assets/r_kEY.png")}

@export var item_buttons : Dictionary[String, Texture2D] = {"Carimbo Azul": preload("res://Assets/x_bUTTON.png"),
															"Carimbo Laranja": preload("res://Assets/y_bUTTON.png"),
															"Carimbo Frágil": preload("res://Assets/b_bUTTON.png"),
															"Removedor de Carimbo": preload("res://Assets/LB_button.png")}

@export var item_text : Dictionary[String, String] = {"Carimbo Azul": "Superfícies com essa marca concedem velocidade temporária ao entrar em contato.\nEfeito acumulável, até certo ponto.",
														"Carimbo Laranja": "Superfícies com essa marca concedem velocidade vertical temporária ao entrar em contato.\nEfeito acumulável, até certo ponto.",
														"Carimbo Frágil": "Superfícies com essa marca tornam-se frágeis, permitindo que pequenos impactos danifiquem-na.\nBlocos serão respostos.",
														"Removedor de Carimbo": "Permite remover a tinta de áreas carimbadas. Uso ilimitado, um oferecimento @!?#$..."}

func _ready() -> void:
	hide()

func show_tutorial(item_name : String) -> void:
	get_tree().paused = true
	confirm_button.grab_focus()
	title_label.text = item_name
	texture.texture = item_texture[item_name]
	desc_label.text = item_text[item_name]
	key.texture = item_keys[item_name]
	button.texture = item_buttons[item_name]
	
	background.modulate.a = 0.0
	show()
	
	var tween : Tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(background, "modulate:a", 1.0, 1.5)

func _on_confirm_pressed() -> void:
	get_tree().paused = false
	hide()
