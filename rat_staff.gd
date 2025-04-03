extends CharacterBody2D


const SPEED = 50.0
const CHARGE_SPEED = 65
const JUMP_VELOCITY = -400.0
var direction = 1
var health = 10
var attacking = false
var start_position = Vector2()
var dead = false
var can_attack = true
@onready var area : Area2D = $Area2D
var arenatype = 0
var fade_timer = 0.0
var fade_time = 1.0


var is_player_detected = false
@onready var rocket = preload("res://bullet_flying_rat.tscn")
@onready var player = get_node("/root/Node2D/Player")

func _ready():
	health = 10
	start_position = position
	$AnimatedSprite2D.play("idle")
	$spawn_in.play()


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
		move_and_slide()
	# Move the enemy back and forth
	if not attacking:
		$AnimatedSprite2D.play("idle")
		position.x += SPEED * direction * delta
	if dead:
		fade_timer += delta
		modulate.a = 1 - fade_timer / fade_time
		if fade_timer >= fade_time:
			queue_free()	
		
	if player.global_position.x > global_position.x:
		direction = 1
	else:
		direction = -1
	if direction == -1:
		$AnimatedSprite2D.flip_h = true # Flip sprite horizontally to face left
	elif direction == 1:
		$AnimatedSprite2D.flip_h = false
	
	# Flip sprite based on direction
	if direction == -1:
		$AnimatedSprite2D.flip_h = true # Flip sprite horizontally to face left
	elif direction == 1:
		$AnimatedSprite2D.flip_h = false  # Flip sprite horizontally to face right
	
	move_and_slide()
		
func take_damage(damage : int):
	if not dead:
		health -= damage
		if health <= 0:
			die()
		
func die():
	$whycantheywalkthroughwallsivebeentryingtofixitallmorningwhyyyy.play()
	var arenas = get_tree().get_nodes_in_group("arenas")
	if not dead:
		dead = true
		velocity = Vector2(0,0)
		for arena in arenas:
			if arena != null and arena.arenatype == arenatype:
				arena.update_arena(1)
		$AnimatedSprite2D.play("dead")
		$CPUParticles2D.emitting = true
		await $CPUParticles2D.finished
		


func crash_out():
	if player.global_position.x > global_position.x:
		direction = 1
	else:
		direction = -1
	if direction == -1:
		$AnimatedSprite2D.flip_h = true # Flip sprite horizontally to face left
	elif direction == 1:
		$AnimatedSprite2D.flip_h = false
	
	if is_player_detected and player and can_attack:
		can_attack = false
		attacking = true
		var attack_direction = (player.global_position - global_position).normalized()
		$AnimatedSprite2D.play("aim")
		await $AnimatedSprite2D.animation_finished
		var timer = $Timer
		timer.wait_time = 1.0
		timer.start()
		await timer.timeout
		for i in 3:
			$AnimatedSprite2D.play("fire")
			var projectile = rocket.instantiate()
			projectile.scale += Vector2(0.5,0.5)
			projectile.position += Vector2(30 * direction, 15)
			projectile.rotation = attack_direction.angle() + randi_range(-45, 45)
			add_child(projectile)
			$AudioStreamPlayer2D.play()
			await $AnimatedSprite2D.animation_finished
		
		
		$AnimatedSprite2D.play("aim")
		attacking = false
		timer.wait_time = 2.0
		timer.start()
		await timer.timeout
		can_attack = true
		if is_player_detected:
			crash_out()
		


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = body
		is_player_detected = true
		crash_out()


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = body
		is_player_detected = false
