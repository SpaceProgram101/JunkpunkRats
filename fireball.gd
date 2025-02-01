extends Area2D  # Or Area2D, depending on your choice

@export var speed: float = 700.0  # Bullet speed
var direction: Vector2 = Vector2.ZERO  # Direction of the bullet movement

@onready var sprite = $AnimatedSprite2D  # Reference to the AnimatedSprite2D

func _ready():
	sprite.play("fireball")  # Replace with your animation name

func _process(delta):
	# Move the bullet in the specified direction
	position += direction * speed * delta
	if position.x > get_viewport().size.x or position.y > get_viewport().size.y:
		queue_free()
	# Optionally add collision handling here (e.g. hit detection)
	# queue_free() or handle impact when collision occurs.
