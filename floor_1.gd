extends StaticBody2D

@onready var player = get_node("/root/Node2D/Player")
@onready var firefly = preload("res://firefly.tscn")
var spawn_timer = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if spawn_timer <= 0:
		spawn_fireflies(randi_range(3,7))
		spawn_timer = randi_range(3,7)
	elif spawn_timer > 0:
		spawn_timer -= delta
		
func spawn_fireflies(amount: int):
	print ("Spawning fireflies.")
	for i in amount:
		var spawn = firefly.instantiate()
		spawn.global_position = player.global_position
		add_child(spawn)
