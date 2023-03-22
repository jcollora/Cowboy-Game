extends RigidBody2D
## Represents a bullet

var damage: int
var player


func _on_body_entered(body):
	print("hi")
	queue_free()
