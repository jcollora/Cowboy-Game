extends "res://entities/interactables/interactable.gd"
# Keeps track of the state of tables (if they are knocked over for cover or not)
# Also will keep track of health for future destructability

## The state of the current table
@export_group("Table State")
@export var default_activated: bool = false
@export var default_health: int = 10

# Setting of current state
@onready var health = default_health
@onready var isActivated = default_activated

@onready var _collider = $TableCollider
@onready var _anim_table = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Assumes player can interact with this interactable
func interact(player):
	var dir = player.position - self.position
	# if the player is above the table: down
	if(dir[1] > 0):
		_anim_table.play("flip_up")
	# if the player is below the table: up
	else:
		_anim_table.play("flip_down")

