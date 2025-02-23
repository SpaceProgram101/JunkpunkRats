extends Node

var has_cutscene_played = false  # This resets when the game restarts
@onready var theFnafMovie = $VideoStreamPlayer


func _ready():
	if has_cutscene_played:
		print("Cutscene already played this session. Skipping.")
		return
	has_cutscene_played = true
	print("Playing cutscene for the first time this session.")
	theFnafMovie.play()
func _input(event):
	if event.is_action_pressed("ui_accept"):
		theFnafMovie.stop()
		print ("Skipping cutscene.")
