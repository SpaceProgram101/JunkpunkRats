extends CharacterBody2D

@onready var player = get_node("/root/Node2D/Player")
@onready var enemy_scene = preload("res://flying_rat.tscn")
var original_position : Vector2
var is_flying_to_player : bool = false
var is_waiting : bool = false
var is_flying_away : bool = false
var speed = 150
@onready var wait_timer = Timer.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	original_position = position
	visible =false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("DIE"):
		if is_flying_to_player:
			fly_towards_player()
		elif is_waiting:
			pass
		elif is_flying_away:
			fly_away()
			
func start_flying_to_player():
	is_flying_to_player = true
	is_waiting = false
	is_flying_away = false
	
func fly_towards_player():
	var target_position = player.position + Vector2(0, -50)
	var direction = (target_position-position).normalized()
	
	velocity = direction * speed
	move_and_slide()
	
	if position.distance_to(target_position) < 10:
		pass
		
func fly_away():
	pass
	
	
func spawn_enemy():
	visible = true
	$AnimatedSprite2D.play("approach")
	position = player.position + Vector2(50, 50)
	
	print ("Spawning enemy.")
	position = player.position
	var enemy = enemy_scene.instantiate()
	get_parent().add_child(enemy)
	
	
