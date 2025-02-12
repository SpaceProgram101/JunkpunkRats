extends Camera2D

var player : CharacterBody2D

func _ready():
	player = get_node("/root/Node2D/Player") 
	print ("Node:", player) # Reference your player node here
  # Camera's offset

func _process(_delta):
	position = player.position 
	position.y += 50 # Makes camera follow the player
