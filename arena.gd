extends Area2D
@onready var player = get_node("/root/Node2D/Player")
@onready var spawn = preload("res://spawner.tscn")
@onready var timer = get_node("Timer")
@onready var sprite = $AnimatedSprite2D

@onready var left_wall = $left_area/left_wall
@onready var right_wall = $right_area/right_wall
@onready var left_tree = $left_area/left_anim
@onready var right_tree = $right_area/right_anim

#Decide how many enemies to spawn of what type depending on the specific arena.
@export var warrior : int
@export var helicopter : int
@export var staff : int
@export var rocket : int


var should_continue = true
var arena_progress = 0
var arena_max = 1
var spawn_count = 0
@export var progress_bar : ProgressBar
var arena_started_yet = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	arena_max = warrior + helicopter + staff + rocket
	print (arena_max)
	left_wall.disabled = true
	right_wall.disabled = true
	
	$AnimatedSprite2D.play("default")
	progress_bar.value = 0
	$AnimatedSprite2D.visible = true
	$AnimatedSprite2D/PointLight2D.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

#rand number 1-4
#if number = X, reduce the # of that type of enemy by 1
#then, return the random number
#if the enemy # is 0 or less, instead run the function again
#repeat until a suitable number is established.

func decide_enemy():
	var pool = warrior + helicopter + staff + rocket
	var output = 0
	var repeat = true
	while repeat:
		output = randi_range(1,4)
		if pool == 0:
			should_continue = false
			repeat = false
			return 0
		elif output == 1:
			if warrior > 0:
				warrior -= 1
				repeat = false
			elif warrior <= 0:
				repeat = true
		elif output == 2:
			if helicopter > 0:
				helicopter -= 1
				repeat = false
			elif helicopter <= 0:
				repeat = true
		elif output == 3:
			if staff > 0:
				staff -= 1
				repeat = false
			elif staff <= 0:
				repeat = true
		elif output == 4:
			if rocket > 0:
				rocket -= 1
				repeat = false
			elif rocket <= 0:
				repeat = true
	return output

func spawn_enemies():
	for i in range(3):
		var enemy = spawn.instantiate() 
		get_parent().add_child(enemy)
		enemy.position = position
		var offset = randf_range(-7,7) * 10
		enemy.position.x += offset
		enemy.position.y -= 200
		enemy.original_position = enemy.position
		var enemy_to_spawn = decide_enemy()
		print ("Enemy spawning:", enemy_to_spawn)
		enemy.enemytype = enemy_to_spawn
		enemy.is_flying_to_player = true
	

func begin_arena():
	spawn_enemies()
	timer.start()
	await timer.timeout
	if arena_progress < arena_max and should_continue:
		begin_arena()
		
func arena_complete():
	$death.visible = true
	$death.play("default")
	$AnimatedSprite2D.play("death")
	await $death.animation_finished
	$AnimatedSprite2D.visible = false
	$death.visible = false
	
	
	
func update_arena(progress : int):
	arena_progress += progress
	print (arena_progress)
	var progress_percent = (float(arena_progress) / arena_max) * 100
	print (progress_percent, "%")
	
	progress_bar.value = progress_percent
	
	print (progress_bar.value)
	if arena_progress >= arena_max:
		arena_complete()
	
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and not arena_started_yet:
		$AnimatedSprite2D/PointLight2D.visible = true
		begin_arena()
		arena_started_yet = true
		left_tree.play("spawning")
		right_tree.play("spawning")
		await left_tree.animation_finished
		left_wall.disabled = false
		right_wall.disabled = false
		left_tree.play("idle")
		right_tree.play("idle")
	
