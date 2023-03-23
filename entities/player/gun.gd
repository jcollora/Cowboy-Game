extends Node2D
## Represents a gun, shooting damaging projectiles.

@export var base_dmg: int = 20
@export var projectile_speed: int = 200
@export var _projectile_scene: PackedScene

@onready var _gunfire_particle_sys = $GPUParticles2D
@onready var _anim_tree = $"../AnimationTree"
@onready var _player = get_parent()


## Shoot the gun's define projectile in the given direction, with the given damage multiplier.
func shoot(projectile_dmg_multiplier: float, aim_direction: Vector2):
	# Create the projectile and assign its properties
	var projectile = _projectile_scene.instantiate()
	projectile.dmg = base_dmg * projectile_dmg_multiplier
	projectile.attacking_player = _player
	
	# Add the bullet as a child of the root of the scene (to avoid parent-child connencted mvmt)
	get_tree().current_scene.add_child(projectile)
	
	# Set the position to the point of the gun
	projectile.global_position = global_position
	
	# Send the bullet flying via a single impulse
	projectile.apply_central_impulse(aim_direction.normalized() * projectile_speed)
	
	# Have the bullet unable to hit the player
	projectile.add_collision_exception_with(_player)
	
	# Trigger a one-shot playthrough of the gunfire particle system
	_gunfire_particle_sys.emitting = true
