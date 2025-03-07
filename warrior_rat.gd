extends CharacterBody2D


const SPEED = 50.0
const CHARGE_SPEED = 65
const JUMP_VELOCITY = -400.0
var direction = 1
var health = 10
var attacking = false
var start_position = Vector2()
var dead = false
@onready var spawner = get_node("/root/Node2D/Spawner")
@onready var player = get_node("/root/Node2D/Player")

func _ready():
	health = 10
	start_position = spawner.position
	$AnimatedSprite2D.play("idle")

func _physics_process(delta: float) -> void:

	if not dead:
		if position.distance_to(player.position) < 200:
			crash_out(delta)
		elif position.distance_to(player.position) > 200:
			attacking = false
			$AnimatedSprite2D.play("idle")
		
		
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	# Move the enemy back and forth
	
	# Update position based on velocity
	
	# Flip sprite based on direction
	if direction == -1:
		$AnimatedSprite2D.flip_h = true # Flip sprite horizontally to face left
	elif direction == 1:
		$AnimatedSprite2D.flip_h = false  # Flip sprite horizontally to face right

	# Flip direction when reaching a certain distance
	if position.x > start_position.x + 100 and not attacking:  # Move right 200 pixels from start position
		direction = -1  # Move left
	elif position.x < start_position.x - 100 and not attacking: # Move left 200 pixels from start position
		direction = 1  # Move right
	if not attacking:
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
		$AnimatedSprite2D.play("annihilation")
		await $AnimatedSprite2D.animation_finished
		for arena in arenas:
			arena.update_arena(1)
		queue_free()

func crash_out(delta: float):
	if not attacking and not dead:
		$AnimatedSprite2D.play("pure_shock")
		await $AnimatedSprite2D.animation_finished
		attacking = true
	elif attacking and not dead:
		$AnimatedSprite2D.play("attack")
		if player.position.x > position.x:
			direction = 1
		else:
			direction = -1
		if direction == -1:
			$AnimatedSprite2D.flip_h = true # Flip sprite horizontally to face left
		elif direction == 1:
			$AnimatedSprite2D.flip_h = false
		
	
		move_and_slide()
		
	
