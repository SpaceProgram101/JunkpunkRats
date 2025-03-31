extends AudioStreamPlayer2D

@onready var climb_start = preload("res://soundtrack/final_climb_opening.mp3")
@onready var climb_loop = preload("res://soundtrack/final_climb_loop.mp3")
@onready var camera = get_node("/root/Node2D/Camera2D")
var can_play = false
var loop = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if camera.cutscene:
		can_play = true
	if can_play:
		if not loop and not playing:
			stream = climb_start
			play()
	elif not can_play:
		stop()	


func _on_finished() -> void:
	if can_play:
		loop = true
		stream = climb_loop
		play()
