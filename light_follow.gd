extends PointLight2D

@onready var player = get_node("/root/Node2D/Player")
var rotation_speed = 3.0
var rotation_offset = -PI / 2
var active = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enabled = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if active:
		enabled = true
		var direction = player.global_position - global_position
		# Calculate the angle in radians between the sprite and the player
		if direction.length() > 0:	
			var target_angle = direction.angle() + rotation_offset
		# 	Set the sprite's rotation to the calculated angle
			rotation = lerp_angle(rotation, target_angle, rotation_speed * delta)
