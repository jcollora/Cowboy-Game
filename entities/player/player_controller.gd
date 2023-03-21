extends CharacterBody2D

## Reads controller/keyboard input and allows characters to perform actions.

## Player speed while moving. 
const move_speed = 2


func _physics_process(delta):
	# Move the character every physics frame
	_move()


# Moves the character in a direction according to input. Acknowledges wall collision.
func _move():
	var velocity = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	move_and_collide(velocity * move_speed)
