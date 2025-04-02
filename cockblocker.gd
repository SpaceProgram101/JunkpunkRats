extends StaticBody2D

var arenas_left = 5


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Label.text = str(5 - arenas_left)
	if arenas_left <= 0:
		arenas_left = 0
		queue_free()
