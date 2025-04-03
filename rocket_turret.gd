extends Area2D

@onready var player = get_node("/root/Node2D/Player")
@onready var anim = $AnimatedSprite2D
@onready var timer = $Timer
@onready var rocket = preload("res://rat_rocket.tscn")
@onready var finalarena = get_node("/root/Node2D/final_arena")
@onready var death = preload("res://sound files/explosion-289984.mp3")
@onready var smoke = $CPUParticles2D
var health = 10
var can_attack = false
var room_active = true
var offset = PI / 2
var dead = false

func _ready():
	smoke.emitting = false 
	health = 10
	dead = false
	room_active = finalarena.phase1
	anim.play("default")
	timer.start()

func _process(_delta: float):
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
		if not dead:
			add_child(projectile)
		await anim.animation_finished
		timer.start()
		anim.play("default")
		
func take_damage(damage : int):
	if not dead:
		$AudioStreamPlayer2D.pitch_scale = randf_range(1, 1.5)
		$AudioStreamPlayer2D.play()
		health -= damage
		if health <= 0:
			health = 0
			die()
func die():
	$AudioStreamPlayer2D.stream = death
	$AudioStreamPlayer2D.play()
	dead = true
	smoke.emitting = true
	get_parent().rocketcount -= 1
	if anim.flip_h:
		anim.rotation = (PI / 4)
	else: 
		anim.rotation = (-PI / 4)
	anim.play("default")

func _on_timer_timeout() -> void:
	if room_active:
		can_attack = true
