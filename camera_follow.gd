extends Camera2D

var player : CharacterBody2D
var cutscene = false


func _ready():
	player = get_node("/root/Node2D/Player") 
	print ("Node:", player) # Reference your player node here
  # Camera's offset

func _process(_delta):
	position = player.position 
	if cutscene:
		$cutscenebar.visible = true
	else:
		$cutscenebar.visible = false
	position.y += 50 # Makes camera follow the player
