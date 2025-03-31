extends Sprite2D

@onready var lava = $CPUParticles2D
@onready var room = get_node("/root/Node2D/Lava")
var can_pour = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	lava.emitting = false
	can_pour = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	can_pour = room.can_rise
	if can_pour:
		lava.emitting = true
	else:
		lava.emitting = false
