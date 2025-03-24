extends AudioStreamPlayer2D

@onready var wind = preload("res://tiles/wind-morning-27135.mp3")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_finished() -> void:
	play()
