extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var direction = 1
var dead = false
@onready var sprite = $AnimatedSprite2D
@onready var explosion = preload("res://explosion.tscn")
var damage = 15
var explosionyet = false
var fade_timer = 0.0
var fade_time = 1.0


func _ready():
	damage = 15
	explosionyet = false
	visible = true
	$AnimatedSprite2D.play("default")
	direction = Vector2(cos(global_rotation), sin(global_rotation))
	direction = direction.normalized()
	$AudioStreamPlayer2D.play()
	self_modulate = 1

func _physics_process(delta: float) -> void:
	if not dead:
		velocity += direction * SPEED * delta
		move_and_slide()
	elif dead:
		rotation = 0
		if not explosionyet:
			explosionyet = true
			scale = Vector2(0.1,0.1)
		sprite.play("explosion")
		velocity = Vector2(0,0)
		damage = 0
		fade_timer += delta
		modulate.a = 1 - (fade_timer / fade_time)
		scale += Vector2(0.05,0.05) * delta
		if fade_timer >= fade_time or modulate.a <= 0:
			fade_timer = 1.0
			queue_free()
		
