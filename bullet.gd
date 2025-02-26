extends CharacterBody2D


@export var speed : float = 75
var direction : Vector2

func _ready():
	var player = get_parent().get_node("Player")
	direction = (player.position - position).normalized()
	rotation = direction.angle()
	$AnimatedSprite2D.play("default")
	
	
func _physics_process(delta: float) -> void:
	velocity = direction * speed
	move_and_slide()
	
