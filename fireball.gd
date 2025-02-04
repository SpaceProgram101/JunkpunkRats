extends Area2D  # Or Area2D, depending on your choice

@export var knockback_force = 200.0
@export var knockback_duration = 0.2
@export var damage: int = 10
@export var speed: float = 700.0  # Bullet speed
var direction: Vector2 = Vector2.ZERO  # Direction of the bullet movement

@onready var sprite = $AnimatedSprite2D  # Reference to the AnimatedSprite2D
var delete_time = 2.0



func _ready():
	#play the animation fireball
	#$Area2D.connect("body_entered", Callable(self, "_on_body_entered"))
	#$Area2D.connect("area_entered", Callable(self, "_on_area_entered"))
	set_meta("knockback", true)
	
	sprite.play("fireball")  # Replace with your animation name
	var timer = get_tree().create_timer(delete_time)
	#wait for the timer to run out
	await timer.timeout
	#delete fireball
	queue_free()
	
func _process(delta):
	#increment distance by multiplying direction, speed, and the current time.
	speed = randf_range(600,1200)
	position += direction * speed * delta

	# Optionally add collision handling here (e.g. hit detection)
	# queue_free() or handle impact when collision occurs.
	
	# Knockback f1
func _on_body_entered(body):
	print("Collision detected with:", body.name)  # Debugging
	if body.has_method("apply_knockback"):
		body.apply_knockback(knockback_force, knockback_duration, global_position)  # <-- Pass `global_position`
	else:
		printerr("ERROR: Colliding body does not have 'apply_knockback' function")
#knockback f2
func _on_area_entered(area):
	if area.has_method("apply_knockback"):
		area.apply_knockback(knockback_force, knockback_duration, global_position)
	else:
		printerr("Colliding area does not have 'apply_knockback' function")

func _on_Projectile_body_entered(body: Node) -> void:
	if body.is_in_group("enemies"):
		body.take_damage(damage)
		queue_free()
		 
