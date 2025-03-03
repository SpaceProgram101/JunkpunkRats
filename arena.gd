extends Area2D
@onready var player = get_node("/root/Node2D/Player")
@onready var spawn = preload("res://spawner.tscn")
@onready var timer = get_node("Timer")
@onready var sprite = $AnimatedSprite2D

@onready var left_wall = $Wall_Left
@onready var right_wall = $Wall_Right
@onready var left_tree = $Wall_Left/left_anim
@onready var right_tree = $Wall_Right/right_anim


var arena_progress = 0
var arena_max = 1.0
var spawn_count = 0
@export var progress_bar : ProgressBar
var spawntype = 1
var arena_started_yet = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	left_wall.disabled = true
	right_wall.disabled = true
	
	$AnimatedSprite2D.play("default")
	progress_bar.value = 0
	$AnimatedSprite2D.visible = true
	$AnimatedSprite2D/PointLight2D.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func spawn_enemies():
	var enemy = spawn.instantiate() 
	get_parent().add_child(enemy)
	enemy.position = position
	enemy.position.y -= 300
	enemy.enemytype = spawntype
	enemy.original_position = enemy.position
	enemy.is_flying_to_player = true
	

func begin_arena():
	spawn_enemies()
	timer.start()
	await timer.timeout
	if arena_progress < arena_max:
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
	print ("Player detected!")
	if body.is_in_group("player") and not arena_started_yet:
		$AnimatedSprite2D/PointLight2D.visible = true
		begin_arena()
		arena_started_yet = true
		left_wall.disabled = true
		right_wall.disabled = true
		left_tree.play("spawning")
		right_tree.play("spawning")
		await left_tree.animation_finished
		left_tree.play("idle")
		right_tree.play("idle")
	
