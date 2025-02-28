extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D
@export var speed : float = 75
var direction : Vector2
var dead = false
func _ready():
	var player = get_parent().get_node("Player")
	direction = (player.position - position).normalized()
	rotation = direction.angle()
	$AnimatedSprite2D.play("default")
	
	
func _physics_process(_delta: float) -> void:
	if not dead:
		velocity = direction * speed
		move_and_slide()
	
