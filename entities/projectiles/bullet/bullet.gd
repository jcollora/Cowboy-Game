extends RigidBody2D
## Represents a bullet

@export var time_before_despawn: int = 5

var dmg: float
var attacking_player: CharacterBody2D


func _ready():
	await get_tree().create_timer(time_before_despawn).timeout
	queue_free()


func _on_body_entered(body):
	if body.get_collision_layer() == 0b10:  # player layer is layer 2
		body.take_damage(dmg, attacking_player)
	queue_free()
