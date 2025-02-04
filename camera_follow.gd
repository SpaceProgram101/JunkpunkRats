extends Node2D

# Declare variables
var player : Node2D # The player node
var camera : Camera2D # The camera
var parallax_factor : float = 0.5 # The parallax effect speed for the background

func _ready():
	# Get the Camera2D and Player nodes
	player = get_node("/root/Node2D/Player") # Change "Player" to the exact name of your player node
	camera = get_node("/root/Node2D/Camera2D") # Make sure Camera2D is in the scene
	
	# Ensure the camera is set to follow the player, but not directly attached
	camera.offset = Vector2.ZERO

func _process(_delta):
	# Make the camera follow the player
	camera.position = player.position

	# Parallax background effect: Move background at a slower speed
	var camera_position = camera.position
	var background = get_node("root/Node2D/background_2") # Change "Background" to the name of your background node
	background.position = camera_position * parallax_factor
