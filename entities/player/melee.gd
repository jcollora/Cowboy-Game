extends Area2D
## Controls melee hitbox behavior

@export var base_dmg: int = 20

@onready var _hitbox = $CollisionShape2D
@onready var _anim_player = $"../AnimationPlayer"
@onready var _anim_tree = $"../AnimationTree"
@onready var _player = get_parent()
@onready var _hit_players = []
var _hitbox_active = false
var _dmg


# For a certain time, have enemies take damage from this melee hit box
func melee(melee_dmg_multiplier: float, melee_hitbox_duration: float):
	_dmg = base_dmg * melee_dmg_multiplier
	_hit_players.clear()
	
	_hitbox.disabled = false
	await get_tree().create_timer(melee_hitbox_duration).timeout
	_hitbox.disabled = true


func _on_body_entered(body):
	if body.get_collision_layer() == 0b10 and body != _player and !_hit_players.has(body):
		_hit_players.append(body)
		body.take_damage(_dmg, _player)