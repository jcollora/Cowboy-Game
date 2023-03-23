extends Node2D
## Represents a gun, shooting damaging projectiles.

@export var base_dmg: int = 20
@export var projectile_speed: int = 200
@export var _projectile_scene: PackedScene
@export var time_between_shots = .2
@export var time_to_reload = 1
@export var clip_size = 6
@export var automatic = false

@onready var _gunfire_particle_sys = $GPUParticles2D
@onready var _anim_player = $"../AnimationPlayer"
@onready var _anim_tree = $"../AnimationTree"
@onready var _player = get_parent()

@onready var _ammo_in_clip = clip_size


func _ready():
	# Animation length controls how fast the player shoots/reloads
	_anim_player.get_animation("player_shoot_left").set_length(time_between_shots)
	_anim_player.get_animation("player_shoot_right").set_length(time_between_shots)
	_anim_player.get_animation("player_reload_left").set_length(time_to_reload)
	_anim_player.get_animation("player_reload_right").set_length(time_to_reload)


## Shoot the gun's define projectile in the given direction, with the given damage multiplier.
func shoot():
	_ammo_in_clip -= 1
	
	_player.disable_action(time_between_shots)
	
	# Create the projectile and assign its properties
	var projectile = _projectile_scene.instantiate()
	projectile.dmg = base_dmg * _player.projectile_dmg_multiplier
	projectile.attacking_player = _player
	
	# Add the bullet as a child of the root of the scene (to avoid parent-child connencted mvmt)
	get_tree().current_scene.add_child(projectile)
	
	# Set the position to the point of the gun
	projectile.global_position = global_position
	
	# Send the bullet flying via a single impulse
	projectile.apply_central_impulse(_player.get_aim_direction() * projectile_speed)
	
	# Have the bullet unable to hit the player
	projectile.add_collision_exception_with(_player)
	
	# Trigger a one-shot playthrough of the gunfire particle system
	_gunfire_particle_sys.emitting = true
	

func auto_reload_if_needed():
	if _ammo_in_clip <= 0:
		_player.play_animation_in_direction(_player.get_aim_direction(), "player_reload")
		_ammo_in_clip = clip_size
		_player.disable_action(time_to_reload)
