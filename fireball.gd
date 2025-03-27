extends Area2D  # Or Area2D, depending on your choice

@export var knockback_force = 200.0
@export var knockback_duration = 0.2
@export var damage: int = 2
@onready var speed = 600 # Bullet speed
var direction: Vector2 = Vector2.ZERO  # Direction of the bullet movement # Reference to the AnimatedSprite2D
@onready var delete_time = 2.0
var contact = false
@onready var sprite = $AnimatedSprite2D
@onready var kurtKobain = $gunshot

func _ready():
	direction = Vector2(cos(global_rotation), sin(global_rotation)) * -1
	#normalize the direction, idrk what this means but it should be included ig
	direction = direction.normalized()
	sprite.modulate.a = 5
	$AnimatedSprite2D.play("fireball")  
	kurtKobain.play()
	
func _process(delta):
	if not contact:
		position += direction * speed * delta
	delete_time -= delta
	if delete_time <= 0:
		queue_free()
	#increment distance by multiplying direction, speed, and the current time.

func _on_body_entered(body: Node2D) -> void:
	contact = true
	if body.is_in_group("enemies"):
		body.take_damage(damage)
	$AnimatedSprite2D.play("explode")  
	await $AnimatedSprite2D.animation_finished
	queue_free()	


func _on_area_entered(area: Area2D) -> void:
	contact = true
	if area.is_in_group("enemies"):
		area.take_damage(damage)
	$AnimatedSprite2D.play("explode")  
	await $AnimatedSprite2D.animation_finished
	queue_free()	
