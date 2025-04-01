extends AudioStreamPlayer

#game states: 1: play first boss 
#2: play entry music
#3: play ascend music, no loop
#4: play ascend music, looped
#5: play final music
@onready var final_boss_internal = preload("res://soundtrack/final_boss_monolith_music.mp3")
@onready var climb_start = preload("res://soundtrack/final_climb_opening.mp3")
@onready var climb_loop = preload("res://soundtrack/final_climb_loop.mp3")
@onready var start = preload("res://soundtrack/final_boss_start_music.mp3")
@onready var first = preload("res://soundtrack/first_boss (1).mp3")
@onready var final_boss_final = preload("res://soundtrack/final_boss_final_music.mp3")
@onready var camera = get_node("/root/Node2D/Camera2D")
var can_play = false
var final_boss_phase1 = false
var should_loop = false
var first_boss = false
var final_boss_phase2 = false
var final_boss_rise = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_finished() -> void:
	if stream == climb_start:
		print("Looping, switching stream to loop version.")
		stream = climb_loop
	play()
