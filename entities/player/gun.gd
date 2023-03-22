extends Node2D
## Shoots damaging projectiles.

@export var base_dmg: int = 20
@export var projectile_speed: int = 200

@onready var _projectile_scene = preload("res://entities/projectiles/bullet/bullet.tscn")
@onready var _particle_sys = $GPUParticles2D
@onready var _player = get_parent()


func shoot(projectile_dmg_multiplier: float, aim_direction: Vector2):
	# Create the projectile and assign its speed and damage
	var projectile = _projectile_scene.instantiate()
	projectile.dmg = base_dmg * projectile_dmg_multiplier
	projectile.attacking_player = _player
	get_tree().current_scene.add_child(projectile)
	projectile.global_position = global_position
	projectile.apply_central_impulse(aim_direction.normalized() * projectile_speed)
	projectile.add_collision_exception_with(get_parent())
	_particle_sys.emitting = true
