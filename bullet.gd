extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D
@export var speed : float = 75
var direction : Vector2
var dead = false
var should_die = false
var damage = 10
@onready var timer = $Timer

func _ready():
	var player = get_node("/root/Node2D/Player")
	direction = (player.global_position - global_position).normalized()
	rotation = direction.angle()
	$AnimatedSprite2D.play("default")
	timer.start()
	
func _physics_process(_delta: float) -> void:
	if not dead:
		velocity = direction * speed
		move_and_slide()
	if dead and not should_die:
		should_die = true
		$AnimatedSprite2D.play("death")
		await $AnimatedSprite2D.animation_finished
		queue_free()


func _on_timer_timeout() -> void:
	dead = true
