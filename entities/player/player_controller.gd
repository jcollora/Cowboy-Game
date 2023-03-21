extends CharacterBody2D
## Reads controller/keyboard input and allows characters to perform actions.
## Also manages player stats, such as strength or money.

## The player's base stats. Affects damage, move speed, etc.
@export_group("Base stats")
@export var base_speed: int = 10
@export var base_strength: int = 10
@export var base_defense: int = 4
@export var base_health: int = 100
@export var base_money: int = 100

## The player's current stats, which start equivalent to their base stats.
@onready var speed = base_speed
@onready var strength = base_strength
@onready var defense = base_defense
@onready var health = base_health
@onready var money = base_money

## Multiplier that controls how much the speed stat affects move speed.
@export var move_speed_multiplier: float = 7

@export var damage_invulnerability_mask: int = 3

## Rolling parameters
@export var roll_speed: float = 100
@export var roll_time_duration: float = 0.6
@export var roll_time_start_invuln: float = 0.1
@export var roll_invuln_duration: float = 0.4

var _roll_direction = null

# Controls whether the player can currently act
var _can_act = true

# Monitors current actions
var _is_rolling = false

# Timers
var _timer_invulnerability = 0

@onready var _interactable_range = $InteractableRange
@onready var _anim_player = $AnimationPlayer


func _input(event):
	if _can_act:
		if event.is_action_pressed("interact"):
			_interact()
		elif event.is_action_pressed("roll"):
			_start_roll()


func _physics_process(delta):
	if _can_act:
		_move()
	
	if _is_rolling:
		_roll()
	
	if _timer_invulnerability > 0:
		# Make invulnerable
		set_collision_mask_value(damage_invulnerability_mask, false)
		
		# Decrease timer
		_timer_invulnerability -= delta
		if _timer_invulnerability <= 0:
			print("remove invuln")
			set_collision_mask_value(damage_invulnerability_mask, true)
			_timer_invulnerability = 0


# Moves the character in a direction according to input. Acknowledges wall collision.
func _move():
	var move_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = move_direction * (1 + speed * move_speed_multiplier)
	move_and_slide()


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


func _start_roll():
	# Check player input to determine roll direction
	_roll_direction = Input.get_vector("move_left", "move_right", "move_up", 
			"move_down").normalized()
	
	# If no direction is held, don't roll
	if _roll_direction == Vector2.ZERO:
		return
	
	# Start the roll anim
	var roll_anim = _anim_player.get_animation("player_roll")
	roll_anim.length = roll_time_duration
	roll_anim.track_set_key_time(0, 1, roll_time_duration)
	_anim_player.play("player_roll")
	
	# Give invlun for a time
	add_invuln(roll_invuln_duration)
	
	# Start the roll movement
	_is_rolling = true
	_can_act = false
	print("cant act")
	await get_tree().create_timer(roll_time_duration).timeout
	print("can act")
	_is_rolling = false
	_can_act = true


# Roll in the current movement direction, giving invulnerability.
func _roll():
	velocity = _roll_direction * roll_speed
	move_and_slide()


func add_invuln(duration: float):
	print("add invuln")
	if _timer_invulnerability < duration:
		_timer_invulnerability = duration
