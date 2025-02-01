extends Area2D  # Or Area2D, depending on your choice

@export var speed: float = 700.0  # Bullet speed
var direction: Vector2 = Vector2.ZERO  # Direction of the bullet movement

@onready var sprite = $AnimatedSprite2D  # Reference to the AnimatedSprite2D
var delete_time = 2.0


func _ready():
	sprite.play("fireball")  # Replace with your animation name
	var timer = get_tree().create_timer(delete_time)

	await timer.timeout
	
	queue_free()
	
func _process(delta):
	# Move the bullet in the specified direction
	position += direction * speed * delta

	# Optionally add collision handling here (e.g. hit detection)
	# queue_free() or handle impact when collision occurs.
