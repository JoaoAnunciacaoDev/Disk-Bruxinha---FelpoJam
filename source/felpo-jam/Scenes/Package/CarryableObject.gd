extends CharacterBody2D
class_name CarryableObject

enum States {
	Dropped,
	Pickupable,
	Carry,
	Launched
}

@export var sprite : Sprite2D
@export var throw_velocity : Vector2
var carrier : Player
var carry_position : Vector2
var gravity : Vector2 = Vector2(0, 700)
var last_direction : float

var state : States

func _physics_process(delta: float) -> void:
	if carrier:
		carry_position = carrier.carry_position
	
	match state:
		States.Carry:
			global_position = carry_position
			sprite.rotation = carrier.all_body_sprite.rotation
			
		States.Dropped:
			velocity.y += delta * gravity.y
			sprite.rotation = 0.0
			if is_on_floor():
				SfxManager.play_sfx("box")
				velocity = Vector2.ZERO
				state = States.Pickupable
			
		States.Launched:
			velocity.y += delta * gravity.y
			var collision_info = move_and_collide(velocity * delta)
			var normal : Vector2 
			
			if collision_info:
				
				normal = collision_info.get_normal()
				
				var target_rotation : float = atan2(normal.x, normal.y)
				velocity = velocity.bounce(normal.normalized()) / Vector2(2.0, 2.0)
				sprite.rotation = lerp_angle(sprite.rotation, target_rotation, 10.0 * delta)
			
				if is_on_floor():
					SfxManager.play_sfx("caixa")
					velocity = velocity.bounce(normal) / Vector2(2.0, 2.0)
					state = States.Dropped
					
		_:
			velocity = Vector2.ZERO
		
	move_and_slide()
