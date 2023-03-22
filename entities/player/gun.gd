extends Node2D
## Shoots damaging projectiles.

@export var damage: int = 20
@export var projectile_speed: int = 200
@onready var _projectile_scene = preload("res://entities/projectiles/bullet/bullet.tscn")


func shoot(aim_direction: Vector2):
	# Create the projectile and assign its speed and damage
	var projectile = _projectile_scene.instantiate()
	projectile.damage = damage
	get_tree().current_scene.add_child(projectile)
	projectile.global_position = global_position
	projectile.apply_central_impulse(aim_direction.normalized() * projectile_speed)
	projectile.add_collision_exception_with(get_parent())
