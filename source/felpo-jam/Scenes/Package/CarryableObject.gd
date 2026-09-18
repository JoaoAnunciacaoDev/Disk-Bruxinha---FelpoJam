extends CharacterBody2D
class_name CarryableObject

signal carrier_updated(has_carrier : bool, body : Node2D)

enum States {
	Dropped,
	Pickupable,
	Carry,
	Launched
}

@export var sprite : Sprite2D
@export var throw_velocity : Vector2

@export_category("Physics")
@export var gravity_force : float = 700.0
@export_range(0.0, 1.0) var bounce_factor : float = 0.55
@export_range(0.0, 1.0) var floor_bounce_factor : float = 0.45
@export_range(0.0, 1.0) var floor_friction : float = 0.75
@export var minimum_bounce_speed : float = 65.0
@export var spin_factor : float = 0.01

var carrier : Player :
	set(value):
		if carrier != value:
			carrier = value
			
			var has_carrier : bool = (carrier != null)
			carrier_updated.emit(has_carrier, self)

var carry_position : Vector2
var last_direction : float

var state : States

func _physics_process(delta: float) -> void:
	if carrier:
		carry_position = carrier.carry_position
	
	match state:
		States.Carry:
			velocity = Vector2.ZERO
			global_position = carry_position
			sprite.rotation = carrier.all_body_sprite.rotation
			
		States.Dropped:
			velocity.y += gravity_force * delta
			move_and_slide()
			sprite.rotation = lerp_angle(sprite.rotation, 0.0, minf(1.0, 12.0 * delta))
			if is_on_floor():
				SfxManager.play_sfx("box")
				velocity = Vector2.ZERO
				state = States.Pickupable
			
		States.Launched:
			velocity.y += gravity_force * delta
			var impact_velocity := velocity
			var collision := move_and_collide(velocity * delta)
			sprite.rotation += velocity.x * spin_factor * delta

			if collision:
				var normal := collision.get_normal().normalized()
				var is_floor_impact := normal.dot(Vector2.UP) > 0.7
				var retained_velocity := floor_bounce_factor if is_floor_impact else bounce_factor

				on_launched_collision(collision, impact_velocity)
				velocity = impact_velocity.bounce(normal) * retained_velocity
				SfxManager.play_sfx("box")

				if is_floor_impact:
					velocity.x *= floor_friction
					if absf(velocity.y) < minimum_bounce_speed \
					and absf(velocity.x) < minimum_bounce_speed:
						velocity = Vector2.ZERO
						state = States.Pickupable
						sprite.rotation = 0.0
					
		_:
			velocity = Vector2.ZERO

func on_launched_collision(_collision : KinematicCollision2D, _impact_velocity : Vector2) -> void:
	pass
