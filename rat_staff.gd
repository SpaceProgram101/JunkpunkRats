extends CharacterBody2D


const SPEED = 10.0
const CHARGE_SPEED = 65
const JUMP_VELOCITY = -400.0
var direction = 1
var health = 10
var attacking = false
var start_position = Vector2()
var dead = false
var can_attack = true

@onready var area : Area2D = $Area2D
@onready var laser = $laser_detection/laser
@onready var detector = $laser_detection
@onready var spawner = get_node("/root/Node2D/Spawner")

var is_player_detected = false

@onready var player = get_node("/root/Node2D/Player")

func _ready():
	health = 10
	position = spawner.position
	position.y += 50
	start_position = position
	laser.play("default")
	laser.visible = false
	$laser_detection/laser_collider.disabled = true
	$AnimatedSprite2D.play("idle")


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	# Move the enemy back and forth
	if not is_player_detected:
		position.x += SPEED * direction * delta
		
	if position.x > start_position.x + 25 and not attacking:  # Move right 200 pixels from start position
		direction = -1  # Move left
	elif position.x < start_position.x - 25 and not attacking: # Move left 200 pixels from start position
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
		$AnimatedSprite2D.play("dead")
		await $AnimatedSprite2D.animation_finished
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
	
	if is_player_detected and player and can_attack and not dead:
		can_attack = false
		attacking = true
		var attack_direction = (player.position - position).normalized()
		$AnimatedSprite2D.play("aim")
		await $AnimatedSprite2D.animation_finished
		detector.rotation = attack_direction.angle()
		
		
		$AnimatedSprite2D.play("fire")
		laser.visible = true
		$laser_detection/laser_collider.disabled = false
		await $AnimatedSprite2D.animation_finished
		
		laser.visible = false
		attacking = false
		var timer = $Timer
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


func _on_laser_detection_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.take_damage(1)
