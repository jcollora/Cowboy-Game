extends Area2D
## Controls melee hitbox behavior

@export var base_dmg: int = 20
@export var hitbox_duration: float = 0.3

@onready var _player = get_parent()
@onready var _hit_players = []
var _hitbox_active = false
var _dmg


# For a certain time, have enemies take damage from this melee hit box
func melee(melee_dmg_multiplier: float):
	_dmg = base_dmg * melee_dmg_multiplier
	_hit_players.clear()
	_hitbox_active = true
	await get_tree().create_timer(hitbox_duration).timeout
	_hitbox_active = false


# Hurt players within hitbox (but only once)
func _physics_process(delta):
	if _hitbox_active:
		var bodies = get_overlapping_bodies()
		for body in bodies:
			# Check if physics body is a player (player layer is layer 2)
			if body.get_collision_layer() == 0b10 and body != _player and !_hit_players.has(body):
				_hit_players.append(body)
				body.take_damage(_dmg, _player)
