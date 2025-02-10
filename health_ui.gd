extends Control

@onready var player = $/root/Node2D/Player
var camera = Camera2D


func _ready():
	camera = get_node("/root/Node2D/Player/Camera2D")
# Assuming you still want the health bar to follow the player’s position, but not rotate
func _process(_delta):
	if camera:	
	# Get the player's world position and convert it to screen position
		var screen_position = camera.get_screen_center_position()
	
	# Update the health bar position on the screen
		$/root/Node2D/CanvasLayer/HealthUI.position = screen_position
