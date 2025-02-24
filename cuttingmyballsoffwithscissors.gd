extends Node

var has_cutscene_played = false  # This resets when the game restarts
@onready var theFnafMovie = $VideoStreamPlayer


func _ready():
	if has_cutscene_played:
		return
	has_cutscene_played = true
	theFnafMovie.play()
func _input(event):
	if event.is_action_pressed("ui_accept"):
		theFnafMovie.stop()
