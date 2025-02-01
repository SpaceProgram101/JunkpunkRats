extends Area2D  # Or Area2D, depending on your choice

@export var speed: float = 700.0  # Bullet speed
var direction: Vector2 = Vector2.ZERO  # Direction of the bullet movement

@onready var sprite = $AnimatedSprite2D  # Reference to the AnimatedSprite2D
var delete_time = 2.0



func _ready():
	#play the animation fireball
	sprite.play("fireball")  
	#create a timer, set to the delete time (or two seconds)
	var timer = get_tree().create_timer(delete_time)
	#wait for the timer to run out
	await timer.timeout
	#delete fireball
	queue_free()
	
func _process(delta):
	#increment distance by multiplying direction, speed, and the current time.
	position += direction * speed * delta

	# Optionally add collision handling here (e.g. hit detection)
	# queue_free() or handle impact when collision occurs.
