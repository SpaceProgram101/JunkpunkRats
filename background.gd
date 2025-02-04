extends Node2D

# Declare background layers
@onready var background = $/root/Node2D/background_2 # Assuming you are using a Sprite, but it could be a TileMap too
@onready var camera = $/root/Node2D/Camera2D
var parallax_factor : float = 0.5 # Adjust how slow the background moves relative to the player

func _ready():
	# Get the camera and background nodes
	camera = get_node("/root/Node2D/Camera2D")
	background = get_node("/root/Node2D/background_2")  # Or whatever node you are using for your background

func _process(_delta):
	# Move the background based on the player's movement, but slower
	var camera_position = camera.position
	background.position = camera_position * parallax_factor
