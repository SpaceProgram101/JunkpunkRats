extends Button

@onready var scene = preload("res://whatthefuck.tscn").instantiate()
@onready var game_started = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_pressed() -> void:
	get_tree().change_scene_to_file("res://whatthefuck.tscn")
	game_started = true
