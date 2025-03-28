extends AudioStreamPlayer2D

@onready var wind = preload("res://tiles/wind-morning-27135.mp3")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if get_node("/root/Node2D/Camera2D").cutscene:
		stop()


func _on_finished() -> void:
	if not get_node("/root/Node2D/Camera2D").cutscene:
		play()
