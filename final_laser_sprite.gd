extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	visible = get_node("/root/Node2D/final_laser").firing
	get_parent().monitorable = get_node("/root/Node2D/final_laser").firing
