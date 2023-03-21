extends CharacterBody2D
## Reads controller/keyboard input and allows characters to perform actions.
## Also manages player stats, such as strength or money.


var speed: int = 10
var strength: int = 10
var defense: int = 4
var health: int = 100
var money: int = 100

## Player speed while moving. 
const move_speed = 2

@onready var interactable_range = $InteractableRange


func _input(event):
	if event.is_action_pressed("interact"):
		_interact()


func _physics_process(delta):
	_move()


# Moves the character in a direction according to input. Acknowledges wall collision.
func _move():
	var velocity = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	move_and_collide(velocity * move_speed)


# Interact with the closest nearby interactable
func _interact():
	var nearby_interactables = interactable_range.get_overlapping_bodies()
	var closest_interactable = null
	var closest_interactable_dist = INF
	for interactable in nearby_interactables:
		var distance = interactable.position.distance_to(position)
		if distance < closest_interactable_dist:
			closest_interactable_dist = distance
			closest_interactable = interactable
			
	if closest_interactable != null:
		closest_interactable.interact()
