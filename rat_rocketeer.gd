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



var is_player_detected = false
@onready var rocket = preload("res://rat_rocket.tscn")
@onready var player = get_node("/root/Node2D/Player")

func _ready():
	health = 10
	start_position = position
	$AnimatedSprite2D.play("idle")


func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	# Move the enemy back and forth
	
	# Update position based on velocity
		# Flip direction when reaching a certain distance
	if position.x > start_position.x + 100 and not attacking:  # Move right 200 pixels from start position
		direction = -1  # Move left
	elif position.x < start_position.x - 100 and not attacking: # Move left 200 pixels from start position
		direction = 1  # Move right
		
	if player.position.x > position.x:
		direction = 1
	else:
		direction = -1
	# Flip sprite based on direction
	if direction == -1 and not attacking:
		$AnimatedSprite2D.flip_h = true # Flip sprite horizontally to face left
	elif direction == 1 and not attacking:
		$AnimatedSprite2D.flip_h = false  # Flip sprite horizontally to face right


	if not attacking:
		$AnimatedSprite2D.play("idle")
		position.x += SPEED * direction * delta
		move_and_slide()	
		
func take_damage(damage : int):
	if not dead:
		health -= damage
		if health <= 0:
			die()
		
func die():
	var arenas = get_tree().get_nodes_in_group("arenas")
	if not dead:
		dead = true
		print ("Add animation soon.")
		for arena in arenas:
			arena.update_arena(1)
		queue_free()


func crash_out():
	if player.position.x > position.x:
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
		var attack_direction = (player.position - position).normalized()
		$AnimatedSprite2D.play("aim")
		await $AnimatedSprite2D.animation_finished
		print ("Ready to fire")
		var timer = $Timer
		timer.wait_time = 1.0
		timer.start()
		await timer.timeout
		print ("Firing!")
		$AnimatedSprite2D.play("fire")
		var projectile = rocket.instantiate()
		projectile.rotation = attack_direction.angle()
		add_child(projectile)
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
