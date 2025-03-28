extends Area2D

@onready var player = get_node("/root/Node2D/Player")
@onready var anim = $AnimatedSprite2D
@onready var timer = $Timer
@onready var rocket = preload("res://rat_rocket.tscn")
@onready var finalarena = get_node("/root/Node2D/final_arena")
@onready var smoke = $CPUParticles2D
var health = 10
var can_attack = false
var room_active = true
var offset = PI / 2
var dead = false

func _ready():
	smoke.emitting = false 
	health = 5
	dead = false
	room_active = finalarena.phase1
	anim.play("default")
	timer.start()

func _process(delta: float):
	room_active = finalarena.phase1
	if can_attack and not dead:	
		timer.stop()	
		anim.play("aiming")
		var target = (player.global_position - anim.global_position).normalized()
		anim.rotation = target.angle()
		if not $AnimatedSprite2D.flip_h:
			anim.rotation += PI
		can_attack = false
		await anim.animation_finished
		anim.play("firing")
		var projectile = rocket.instantiate()
		projectile.rotation = anim.rotation 
		projectile.scale += Vector2(1,1)
		if not $AnimatedSprite2D.flip_h:
			projectile.rotation += PI
		add_child(projectile)
		await anim.animation_finished
		timer.start()
		anim.play("default")
		
func take_damage(damage : int):
	if not dead:
		health -= damage
		if health <= 0:
			die()
func die():
	dead = true
	smoke.emitting = true
	get_parent().rocketcount -= 1
	if anim.flip_h:
		rotation = (PI / 4)
	else: 
		rotation = (-PI / 4)
	anim.play("default")

func _on_timer_timeout() -> void:
	if room_active:
		can_attack = true
