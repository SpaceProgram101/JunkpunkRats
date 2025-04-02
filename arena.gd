extends Area2D
@onready var player = get_node("/root/Node2D/Player")
@onready var spawn = preload("res://spawner.tscn")
@onready var timer = get_node("Timer")
@onready var sprite = $AnimatedSprite2D
@onready var siren = $AnimatedSprite2D/PointLight2D

var siren_active = false
var arenatype = 0 

@onready var left_wall = $left_area/left_wall
@onready var right_wall = $right_area/right_wall
@onready var left_tree = $left_area/left_anim
@onready var right_tree = $right_area/right_anim

#Decide how many enemies to spawn of what type depending on the specific arena.
var helicopter = 0
var warrior = 0
var staff = 0
var rocket = 0
var increase = false
var target = 0


var should_continue = true
var arena_progress = 0
var arena_max = 1
var spawn_count = 0
@export var progress_bar : ProgressBar
var arena_started_yet = false

var dead = false
var fade_timer = 0.0
var fade_time = 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	progress_bar.value = 0
	left_wall.disabled = true
	right_wall.disabled = true
	left_tree.visible = false
	right_tree.visible = false
	
	$AnimatedSprite2D.play("default")
	$AnimatedSprite2D.visible = true
	$AnimatedSprite2D/PointLight2D.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if increase:
		progress_bar.value = lerp(progress_bar.value, float(target), get_process_delta_time() * 2.0)
		if progress_bar.value >= target:
			increase = false
	if siren_active:
		siren.rotation += (PI / 6) * delta 
	if dead:
		fade_timer += delta
		modulate.a = 1 - fade_timer / fade_time
		if fade_timer >= fade_time:
			queue_free()	
			
				
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
		enemy.arenatype = arenatype
		enemy.position.x += offset
		enemy.position.y -= 150
		enemy.original_position = enemy.position
		var enemy_to_spawn = decide_enemy()
		enemy.enemytype = enemy_to_spawn
		enemy.is_flying_to_player = true
	

func begin_arena():
	spawn_enemies()
	timer.start()
	await timer.timeout
	if arena_progress < arena_max and should_continue:
		begin_arena()
		
func arena_complete():
	should_continue = false
	siren_active = false
	print ("Arena complete!")
	$death.visible = true
	$death.play("default")
	await $death.animation_finished
	$ProgressBar.visible = false
	$AnimatedSprite2D.visible = false
	$death.visible = false
	left_tree.play("despawn")
	right_tree.play("despawn")
	left_wall.disabled = true
	right_wall.disabled = true
	await left_tree.animation_finished
	if arenatype <= 5:
		get_node("/root/Node2D/cockblocker").arenas_left -= 1
	if arenatype >= 6 and arenatype < 10:
		get_node("/root/Node2D/cockblocker2").arenas_left -= 1
	if arenatype >= 10:
		get_node("/root/Node2D/cockblocker3").arenas_left -= 1
	dead = true
	
	
	
	
	
func update_arena(progress : int):
	target = (float(arena_progress + progress) / arena_max) * 100
	arena_progress += progress
	if arena_progress >= arena_max:
		arena_complete()
	increase = true
	
	
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and not arena_started_yet:
		player.respawn_position = player.position
		$AnimatedSprite2D.play("active")
		siren_active = true
		$AnimatedSprite2D/PointLight2D.visible = true
		begin_arena()
		arena_started_yet = true
		left_tree.visible = true
		right_tree.visible = true
		left_tree.play("spawning")
		right_tree.play("spawning")
		await left_tree.animation_finished
		left_wall.disabled = false
		right_wall.disabled = false
		left_tree.play("idle")
		right_tree.play("idle")
	
