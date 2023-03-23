extends Area2D
## Controls melee hitbox behavior

@export var base_dmg: int = 20

@onready var _hitbox = $CollisionShape2D
@onready var _anim_player = $"../AnimationPlayer"
@onready var _anim_tree = $"../AnimationTree"
@onready var _player = get_parent()

@onready var _hit_players = []
var _dmg


# For a certain time, have enemies take damage from this melee hit box
func setup_melee():
	_dmg = _player.melee_dmg_multiplier * base_dmg
	_hit_players.clear()


func _on_body_entered(body):
	if body.get_collision_layer() == 0b10 and body != _player and !_hit_players.has(body):
		_hit_players.append(body)
		body.take_damage(_dmg, _player)
