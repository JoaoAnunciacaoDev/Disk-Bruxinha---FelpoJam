extends Sprite2D

@export var player : Player
@export var anim_player : AnimationPlayer
@export var raycast_ground : RayCast2D
@export var raycast_wall : RayCast2D
@export_range(1.0, 60.0, 1.0) var follow_speed : float = 24.0
@export_range(0.05, 0.5, 0.01) var pop_up_duration : float = 0.18
@export_range(0.05, 0.5, 0.01) var pop_down_duration : float = 0.12

var visibility_tween : Tween
var is_presented : bool = false

func _ready() -> void:
	scale = Vector2.ZERO
	hide()

func _process(_delta: float) -> void:
	if not player.show_crosshair:
		set_crosshair_presented(false)
		return

	var target := player.stamp_component.get_stamp_target()
	if target.is_empty():
		set_crosshair_presented(false)
		return

	# Enquanto o jogador mira, acompanha o ponto real do raycast sobre a
	# superfície. Ao carimbar, converge para o centro da célula selecionada.
	# A posição usada pelo StampComponent continua sempre sendo a célula exata.
	var target_position : Vector2 = (
		target["center"] if player.is_stamping else target["visual_position"]
	)
	if not is_presented:
		# Ao reaparecer, evita atravessar a tela partindo da posição antiga.
		global_position = target_position
	else:
		# O alvo lógico continua preso ao tile; somente a imagem da mira desliza.
		# A interpolação exponencial mantém a mesma sensação em qualquer FPS.
		var weight := 1.0 - exp(-follow_speed * _delta)
		global_position = global_position.lerp(target_position, weight)
	set_crosshair_presented(true)

func set_crosshair_presented(should_present : bool) -> void:
	if should_present == is_presented:
		return

	is_presented = should_present
	if visibility_tween and visibility_tween.is_valid():
		visibility_tween.kill()

	anim_player.stop()
	visibility_tween = create_tween()
	if should_present:
		show()
		scale = Vector2.ZERO
		visibility_tween.tween_property(self, "scale", Vector2.ONE, pop_up_duration) \
			.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	else:
		visibility_tween.tween_property(self, "scale", Vector2.ZERO, pop_down_duration) \
			.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
		visibility_tween.finished.connect(_finish_hiding)

func _finish_hiding() -> void:
	if not is_presented:
		hide()

func play_squash() -> void:
	if visibility_tween and visibility_tween.is_valid():
		visibility_tween.kill()
	scale = Vector2.ONE
	anim_player.play("squash")
