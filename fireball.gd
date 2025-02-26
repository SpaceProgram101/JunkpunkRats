extends Area2D  # Or Area2D, depending on your choice

@export var knockback_force = 200.0
@export var knockback_duration = 0.2
@export var damage: int = 10
@onready var speed = 1300 # Bullet speed
var direction: Vector2 = Vector2.ZERO  # Direction of the bullet movement # Reference to the AnimatedSprite2D
var delete_time = 2.0



func _ready():
	direction = Vector2(cos(global_rotation), sin(global_rotation)) * -1
	#normalize the direction, idrk what this means but it should be included ig
	direction = direction.normalized()
	$AnimatedSprite2D.play("fireball")  
	#create a timer, length of which is the delete time
	var timer = get_tree().create_timer(delete_time)
	#wait for the timer to run out
	await timer.timeout
	#delete fireballc
	queue_free()
	
func _process(delta):
	position += direction * speed * delta
	
	#increment distance by multiplying direction, speed, and the current time.


func _on_bullet_body_entered(body):
	print (body.is_in_group("enemies"))
	if body.is_in_group("enemies"):
		body.take_damage(damage)
		queue_free()
