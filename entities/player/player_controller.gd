extends Node

## player_controller reads controller/keyboard input and allows characters to perform actions.

func _input(event):
	var velocity = Input.get_vector("move_left", "move_right", "move_forward", "move_back")

func _move():
	var velocity = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	
