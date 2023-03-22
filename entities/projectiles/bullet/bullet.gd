extends RigidBody2D
## Represents a bullet

var damage: int
var player


func _on_body_entered(body):
	queue_free()
