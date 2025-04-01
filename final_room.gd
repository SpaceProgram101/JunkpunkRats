extends StaticBody2D

@onready var door = $door
@onready var door_col = $door_collision
@onready var lava = get_node("/root/Node2D/Lava")
@onready var player_audio = get_node("/root/Node2D/AudioStreamPlayer")
var open = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("DIE"):
		open_door()
	if open:
		door.rotation += (PI/6) * delta
		door_col.rotation = door.rotation
		door_col.position = door.position + Vector2(-1 ,10)
		if door.rotation >= PI / 2:
			door.rotation = PI / 2
			if not lava.cinema:
				open = false
			

func open_door():
	open = true
	player_audio.stream = player_audio.climb_start
	player_audio.play()
