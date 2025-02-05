extends CharacterBody2D

@export var attack_range: float = 400
@export var animated_sprite = AnimatedSprite2D
const JUMP_VELOCITY = 600
const SPEED = 150
var gravity = 600
var player  : Node2D
var is_dropping = false
var active = false
@onready var timer = $Timer
var is_jumping_attack = false
var direction = -1

var jump_time = 1.0
var jump_progress = 0.0

func _ready():
	player = get_node("/root/Node2D/Player")
	$AnimatedSprite2D.play("falling")

func _physics_process(delta):
	if player.position.x > position.x:
		direction = 1
	else:
		direction = -1
	
	if direction == -1:
		$AnimatedSprite2D.flip_h = true # Flip sprite horizontally to face left
	elif direction == 1:
		$AnimatedSprite2D.flip_h = false 
	
	if not active:
		if position.distance_to(player.position) < attack_range:
			if not is_on_floor():
				self.collision_layer = 0
				$AnimatedSprite2D.play("falling")
				position.y += gravity * delta
				move_and_slide()
			elif is_on_floor():
				self.collision_layer = 1
				active = true
				$AnimatedSprite2D.play("recovery")
				await $AnimatedSprite2D.animation_finished
				$AnimatedSprite2D.play("roar")
				print("shaking")
				$/root/Node2D/Player/Camera2D.shake(5, 3)
				await $AnimatedSprite2D.animation_finished
				cooldown()
	elif active:
		if is_jumping_attack:
			jump_towards_player(delta)
		else: 
			velocity = Vector2.ZERO
			move_and_slide()
	

	
func cooldown():
	active = true
	timer.start()
	print ("Timer started.")
	if timer.is_connected("timeout",Callable(self,"_on_Timer_timeout")):
		timer.disconnect("timeout",Callable(self,"_on_Timer_timeout"))	
	timer.connect("timeout",Callable(self,"_on_Timer_timeout"))
	
func _on_Timer_timeout():
	print ("Timer stopped.")
	choose_attack()
	
func choose_attack():
	var attack_type = randi() % 2
	if attack_type == 0:
		start_jump_attack()
	else:
		punch_attack()
			
func punch_attack():
	$AnimatedSprite2D.play("punch")
	await $AnimatedSprite2D.animation_finished
	$AnimatedSprite2D.play("idle")
	
func jump_towards_player(delta):
	collision_mask = 2
	jump_progress += delta / jump_time
			
	var direction_to_player = (player.position - position).normalized()
	
	velocity.x = direction_to_player.x * SPEED
	
	velocity.y = -JUMP_VELOCITY * (1.0 - jump_progress) + gravity * jump_progress
	if jump_progress > 1.0:
		$AnimatedSprite2D.play("hit")
		jump_progress = 1.0
		is_jumping_attack = false
		cooldown()
		collision_mask = 1
	move_and_slide()

	
func start_jump_attack():
	jump_progress = 0.0
	is_jumping_attack = true
	$AnimatedSprite2D.play("jump")
