extends AnimatedSprite2D


var fade_timer = 0.0
var fade_time = 2.0
@onready var spawner = get_node("/root/Node2D/Player")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play("default")
	top_level = true
	global_position = spawner.global_position
	modulate.a = 1
	if spawner.overalldirection == -1:
		flip_h = true
	elif spawner.overalldirection == 1:
		flip_h = false
	await animation_finished
	queue_free()



func _process(_delta):
	pass
