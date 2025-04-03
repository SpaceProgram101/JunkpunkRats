extends StaticBody2D

@onready var player = get_node("/root/Node2D/Player")
@onready var firefly = preload("res://firefly.tscn")
var spawn_timer = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
