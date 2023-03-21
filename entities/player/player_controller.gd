extends CharacterBody2D
## Reads controller/keyboard input and allows characters to perform actions.
## Also manages player stats, such as strength or money.

## The player's base stats. Affects damage, move speed, etc.
@export_group("Base Stats")
@export var base_speed: int = 10
@export var base_strength: int = 10
@export var base_defense: int = 4
@export var base_health: int = 100
@export var base_money: int = 100

## Multiplier that controls how much the speed stat affects move speed.
@export var move_speed_multiplier: float = 0.05

## Roll distance in pixels.
@export var roll_distance: float = 50

## The player's current stats, which start equivalent to their base stats.
@onready var speed = base_speed
@onready var strength = base_strength
@onready var defense = base_defense
@onready var health = base_health
@onready var money = base_money

@onready var _interactable_range = $InteractableRange
@onready var _anim_player = $AnimationPlayer

func _input(event):
	if event.is_action_pressed("interact"):
		_interact()
	elif event.is_action_pressed("roll"):
		_roll()


func _physics_process(delta):
	_move()


# Moves the character in a direction according to input. Acknowledges wall collision.
func _move():
	var move_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	move_and_collide(move_direction + move_direction.normalized() * (speed * move_speed_multiplier))


# Interact with the closest nearby interactable
func _interact():
	var nearby_interactables = _interactable_range.get_overlapping_bodies()
	var closest_interactable = null
	var closest_interactable_dist = INF
	for interactable in nearby_interactables:
		var distance = interactable.position.distance_to(position)
		if distance < closest_interactable_dist:
			closest_interactable_dist = distance
			closest_interactable = interactable
			
	if closest_interactable != null:
		closest_interactable.interact(self)


# Roll in the current movement direction, giving invulnerability.
func _roll():
	# Check player input to determine roll direction
	var roll_direction = Input.get_vector("move_left", "move_right", "move_up", 
			"move_down").normalized()
	
	# If no direction is held, don't roll
	if roll_direction == Vector2.ZERO:
		return
	
	# Set the start and end points for the roll animation
	var roll_startpoint = position
	var roll_endpoint = position + roll_direction * roll_distance
	var roll_anim = _anim_player.get_animation("player_roll")
	roll_anim.track_set_key_value(0, 0, roll_startpoint)
	roll_anim.track_set_key_value(0, 1, roll_endpoint)
	_anim_player.play("player_roll")
