extends AnimatedSprite2D

@onready var player = get_parent()
var fireball_scene = preload("res://fireball.tscn")

var direction = 1
var left = false
var right = false
var up = false
var cooldown = 0.1
var last_shot_time = 0.0
var shooting = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
	


func shoot():
	shooting = true
	var fireball = fireball_scene.instantiate()
	fireball.position.y -= 7
	fireball.global_rotation = global_rotation
	get_parent().add_child(fireball)

	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:	
	if shooting:
		play("firing")
	else:
		play("idle")
	
	if Input.is_action_pressed("attack"):
		var current_time = Time.get_ticks_msec() / 1000.0
		if current_time - last_shot_time > cooldown:
			shoot()
			last_shot_time = current_time
	if not Input.is_action_pressed("attack"):
		shooting = false
			
	if Input.is_action_pressed("ui_left"):
		direction = 1
		left = true
	if Input.is_action_pressed("ui_right"):
		direction = -1
		right = true
	if Input.is_action_just_pressed("ui_up"):
		up = true
	if Input.is_action_just_released("ui_left"):
		left = false
	if Input.is_action_just_released("ui_right"):
		right = false
	if Input.is_action_just_released("ui_up"):
		up = false
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
		if direction == 1:
			flip_v = false
			global_rotation = 0
		elif direction == -1:
			flip_v = true
			global_rotation = PI
