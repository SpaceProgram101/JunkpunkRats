extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var direction = 1
var dead = false
@onready var sprite = $AnimatedSprite2D
var damage = 15

func _ready():
	$AnimatedSprite2D.play("default")
	direction = Vector2(cos(global_rotation), sin(global_rotation))
	direction = direction.normalized()

func _physics_process(delta: float) -> void:
	if not dead:
		velocity += direction * SPEED * delta
		move_and_slide()
