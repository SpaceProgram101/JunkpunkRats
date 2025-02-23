extends CharacterBody2D  # Or Area2D, depending on your choice

@export var knockback_force = 200.0
@export var knockback_duration = 0.2
@export var damage: int = 10
@onready var speed = 500 # Bullet speed
var direction: Vector2 = Vector2.ZERO  # Direction of the bullet movement # Reference to the AnimatedSprite2D
var delete_time = 2.0



func _ready():
	#play the animation fireball
	#$Area2D.connect("body_entered", Callable(self, "_on_body_entered"))
	#$Area2D.connect("area_entered", Callable(self, "_on_area_entered"))
	#set_meta("knockback", true)
	direction = Vector2(cos(global_rotation), sin(global_rotation)) * -1
	direction = direction.normalized()
	$AnimatedSprite2D.play("fireball")  # Replace with your animation name
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
	
	# Knockback f1
