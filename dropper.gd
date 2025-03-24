extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@onready var player = get_node("/root/Node2D/Player")
@onready var flyrat = preload("res://flying_rat.tscn")
@onready var stickrat = preload("res://rat_stick.tscn")
@onready var staffrat = preload("res://rat_staff.tscn")
@onready var rocketrat = preload("res://rat_rocketeer.tscn")
@onready var spawner = get_node("/root/Node2D/FINAL_BOSS")
@onready var steam = $CPUParticles2D
@onready var anim = $AnimatedSprite2D
var fade_out = false
var fade_time = 2.0
var fade_timer = 0.0
var enemy_spawned = false
var gone = false
func _ready():
	fade_out = false
	enemy_spawned = false
	anim.play("default")

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		enemy_spawned = false
		velocity += get_gravity() * delta
	elif is_on_floor() and not enemy_spawned:
		enemy_spawned = true
		anim.play("spawn")
		await anim.animation_finished
		steam.emitting = true
		anim.play("open")
		spawn_enemy()
	if fade_out:
		modulate.a = 1 - (fade_timer/fade_time)
		fade_timer += 0.1
		if fade_timer >= fade_time:
			fade_out = false
			spawner.can_spawn = true
			queue_free()
	move_and_slide()

func spawn_enemy():
	if enemy_spawned:
		var enemytype = randi_range(1,4)
		var enemy
		if enemytype == 1:
			enemy = flyrat.instantiate()
		elif enemytype == 2:
			enemy = stickrat.instantiate()
		elif enemytype == 3:
			enemy = staffrat.instantiate()
		elif enemytype == 4:
			enemy = rocketrat.instantiate()
		get_parent().add_child(enemy)
		enemy.global_position = global_position
		enemy.add_to_group("enemies")
		var timer = $Timer
		timer.wait_time = 2.0
		timer.one_shot = true
		timer.start()
		await timer.timeout
		fade_out = true
