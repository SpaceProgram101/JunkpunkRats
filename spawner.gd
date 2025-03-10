extends CharacterBody2D

@onready var player = get_node("/root/Node2D/Player")
@onready var flyrat = preload("res://flying_rat.tscn")
@onready var stickrat = preload("res://rat_stick.tscn")
@onready var staffrat = preload("res://rat_staff.tscn")
@onready var rocketrat = preload("res://rat_rocketeer.tscn")
var original_position : Vector2
var begin = false
var is_flying_to_player : bool = false
var is_waiting : bool = false
var is_flying_away : bool = false
var speed = 150
var saved_position = Vector2(0, 0)
var target_position = Vector2(0,0)
var target_locked = false
@onready var wait_timer = Timer.new()
var enemytype = 1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	target_position = Vector2(0,position.y - 230)
	$AnimatedSprite2D.play("approach")
	if enemytype == 0:
		queue_free()
	wait_timer.wait_time = 3.0
	add_child(wait_timer)
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if is_flying_to_player:
		fly_towards_player()
	elif is_waiting:
		if enemytype == 0:
			queue_free()
		if enemytype != 0:
			spawn_enemy(enemytype)
			is_waiting = false
	elif is_flying_away:
		fly_away()

	
func start_flying_to_player():
	is_flying_to_player = true
	is_waiting = false
	is_flying_away = false
	
func fly_towards_player():
	velocity.y = speed
	speed -= 1
	move_and_slide()
	
	if speed <= 0:
		is_flying_to_player = false
		is_waiting = true
		speed = 150
		wait_timer.start()
		
func fly_away():
	var direction = (original_position - position).normalized()
	velocity = direction * speed
	move_and_slide()
	if position.distance_to(original_position) < 10:
		is_flying_away = false
		queue_free()
	
	
func spawn_enemy(type : int):
	$AnimatedSprite2D.play("drop")
	await $AnimatedSprite2D.animation_finished
	var enemy
	if type == 1:
		enemy = flyrat.instantiate()
	elif type == 2:
		enemy = stickrat.instantiate()
	elif type == 3:
		enemy = staffrat.instantiate()
	elif type == 4:
		enemy = rocketrat.instantiate()
	else:
		print ("Enemy type is not in range.")
	get_parent().add_child(enemy)
	enemy.add_to_group("enemies")
	enemy.position = position
	if type == 2:
		enemy.position.y += 50  
	$AnimatedSprite2D.play("leave")
	wait_timer.start()
	await wait_timer.timeout
	is_flying_away = true
	
