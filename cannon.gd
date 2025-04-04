extends AnimatedSprite2D

@onready var player = get_node("/root/Node2D/Player")
var fireball_scene = preload("res://fireball.tscn")

var direction = 1
var left = false
var right = false
var up = false
var cooldown = 0.2
var last_shot_time = 0.0
var shooting = false
var aiming = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$PointLight2D.enabled = false
	
	


func shoot():
	if not player.idle:
		$PointLight2D.enabled = true
		$CPUParticles2D.emitting = true
		var fireball = fireball_scene.instantiate()
		fireball.position = position
		fireball.rotation = rotation + deg_to_rad(randi_range(-5,5))
		get_parent().add_child(fireball)
	shooting = true	

	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:	
	if not player.idle:
		position = player.position
		position.y -= 3
		if not shooting and not aiming:
			rotation = 0
	elif player.idle:
		position = player.position
		position.y -= 5
		if player.overalldirection == 1:
			position.x += 5
			rotation = PI / 3
			flip_v = false
		elif player.overalldirection == -1:
			position.x -= 5
			rotation = 2 * (PI / 3)
			flip_v = true
		if aiming: 
			rotation = PI / 2
	if shooting:
		play("firing")
	else:
		play("idle")
	
	if Input.is_action_pressed("attack"):
		var current_time = Time.get_ticks_msec() / 1000.0
		if current_time - last_shot_time > cooldown:
			shoot()
			last_shot_time = current_time
			$PointLight2D.enabled = false
	if not Input.is_action_pressed("attack"):
		shooting = false
			
	if Input.is_action_pressed("left"):
		direction = 1
		left = true
	if Input.is_action_pressed("right"):
		direction = -1
		right = true
	if Input.is_action_just_pressed("up"):
		up = true
		aiming = true
	if Input.is_action_just_released("left"):
		left = false
	if Input.is_action_just_released("right"):
		right = false
	if Input.is_action_just_released("up"):
		up = false
		aiming = false
	if not player.idle:
		if left and up:
			flip_v = false
			global_rotation = PI / 4
		elif right and up:
			flip_v = true
			global_rotation = 3 * PI / 4
		elif up:
			global_rotation = PI / 2
		elif left:
			flip_v = false
			global_rotation = 0
		elif right:
			flip_v = true
			global_rotation = PI
		else:
			if direction == -1:
				flip_v = true
				global_rotation = PI
			elif direction == 1:
				flip_v = false
				global_rotation = 0
