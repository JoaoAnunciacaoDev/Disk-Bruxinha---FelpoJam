extends PanelContainer
class_name MessageDisplay

const CHAR_PER_SECOND : float = 10.0

@export var label : RichTextLabel

var tween : Tween
var texting : bool = false

func _ready() -> void:
	pivot_offset = size / 2
	resized.connect(func(): pivot_offset = size / 2)
	hide()

func set_message(text : String) -> void:
	label.text = text
	display_text()

func display_text() -> void:
	show()
	
	texting = true
	label.visible_characters = 0
	
	var text_length : int = label.text.length()
	var duration : float = text_length / CHAR_PER_SECOND
	
	if tween: tween.kill()
	
	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	tween.set_parallel(true)
	tween.tween_property(self, "modulate:a", 1.0, 0.5)
	tween.tween_property(label, "visible_characters", text_length, duration)

func advance_text() -> void:
	tween.kill()
	label.visible_characters = label.text.length()
	texting = false
