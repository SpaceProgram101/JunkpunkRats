extends Node2D  # Or whatever your main scene's root node type is

# Declare the boss scene
@export var boss_scene : PackedScene

func _ready():
	# Load the boss scene (make sure the path is correct)
	boss_scene = preload("res://rat_king.tscn")
	
	# Instance the boss
	var boss_instance = boss_scene.instantiate()
	
	# Set the boss's position (change these coordinates to where you want him to spawn)
	boss_instance.position = Vector2(400, 100)  # Example position
	
	# Add the boss instance to the scene
	add_child(boss_instance)
