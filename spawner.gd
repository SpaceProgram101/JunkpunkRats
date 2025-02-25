extends Node2D

@onready var player = get_node("/root/Node2D/Player")
@onready var enemy_scene = preload("res://flying_rat.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("DIE"):
		spawn_enemy()
		
func spawn_enemy():
	print ("Spawning enemy.")
	position = player.position
	var enemy = enemy_scene.instantiate()
	get_parent().add_child(enemy)
	
	
