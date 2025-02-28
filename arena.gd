extends Area2D
@onready var player = get_node("/root/Node2D/Player")
@onready var spawn = preload("res://spawner.tscn")
@onready var timer = get_node("Timer")
var arena_progress = 0
var arena_max = 5.0
var spawn_count = 0
@export var progress_bar : ProgressBar
var spawntype = 1
var arena_started_yet = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	progress_bar.value = 0
	$Sprite2D/PointLight2D.visible = false


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
	print ("Beginning arena.")
	spawn_enemies()
	timer.start()
	await timer.timeout
	if arena_progress < arena_max:
		begin_arena()
		

func update_arena(progress : int):
	arena_progress += progress
	print (arena_progress)
	var progress_percent = (float(arena_progress) / arena_max) * 100
	print (progress_percent, "%")
	
	progress_bar.value = progress_percent
	
	print (progress_bar.value)
	if arena_progress >= arena_max:
		print ("Arena complete!")
	
func _on_body_entered(body: Node2D) -> void:
	print ("Player detected!")
	if body.is_in_group("player") and not arena_started_yet:
		$Sprite2D/PointLight2D.visible = true
		begin_arena()
		arena_started_yet = true
	
