extends Area2D

var awake = false
@onready var player = get_node("/root/Node2D/Player")
@onready var boss = get_parent()
var damage = 30
var rotation_offset = PI / 2
var rotation_speed = 0.5
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.play("default")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	awake = boss.awake
	if awake:
		visible = true
		var direction = (player.global_position - global_position).normalized()
		if direction.length() > 0:	
			var target_angle = direction.angle() + rotation_offset
			rotation = lerp_angle(rotation, target_angle, rotation_speed * delta)
			$CollisionShape2D.rotation = rotation
			$CollisionShape2D.position = position
