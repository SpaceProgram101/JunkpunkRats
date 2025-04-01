extends CharacterBody2D


const SPEED = 15.0
const JUMP_VELOCITY = -400.0

@export var health : int = 100
var start_position = Vector2()
var attacking = false
var direction = 1
var arenatype = 0
@onready var player = get_node("/root/Node2D/Player")
@onready var bullet_scene = preload("res://bullet_flying_rat.tscn")
var can_attack = true
var idle = true
var dead = false
var arena_node : Area2D
var hover_height = 0
var hover = false
func _ready():
	health = 10
	$AnimatedSprite2D.play("flying")
	
func _physics_process(delta: float) -> void:	
	if not dead:
		if global_position.distance_to(player.global_position) < 100:
			crash_out()
		elif global_position.distance_to(player.global_position) > 100:
			can_attack = true
			$AnimatedSprite2D.play("flying")
			position.x += SPEED * direction * delta
		
	if direction == -1:
		$AnimatedSprite2D.flip_h = true # Flip sprite horizontally to face left
	elif direction == 1:
		$AnimatedSprite2D.flip_h = false  # Flip sprite horizontally to face right

	if position.x > start_position.x + 100 and not attacking:  # Move right 200 pixels from start position
		direction = -1  # Move left
	elif position.x < start_position.x - 100 and not attacking: # Move left 200 pixels from start position
		direction = 1  # Move right
	if not attacking and not dead:
		move_and_slide()

func take_damage(damage : int):
	if not dead:
		$AnimatedSprite2D.play("hurt")
		health -= damage
		$AnimatedSprite2D.play("flying")
		if health <= 0:
			die()
		
func die():
	var arenas = get_tree().get_nodes_in_group("arenas")
	if not dead:
		for arena in arenas:
			if arena != null and arena.arenatype == arenatype:
				arena.update_arena(1)
		dead = true
		$AnimatedSprite2D.play("dead")
		await $AnimatedSprite2D.animation_finished
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
	if can_attack:
		can_attack = false
		$AnimatedSprite2D.play("attacking")
		await $AnimatedSprite2D.animation_finished
		$AnimatedSprite2D.play("flying")
		var bullet = bullet_scene.instantiate()
		bullet.rotation = (player.global_position - global_position).normalized().angle()
		bullet.position = position + Vector2(0, 10)
		get_parent().add_child(bullet)
		
		var timer = Timer.new()
		add_child(timer)
		timer.wait_time = 3.0
		timer.start()
		await timer.timeout
		can_attack = true
		
