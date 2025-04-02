extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@export var health : int = 100
var current_health : int = 100
var start_position = Vector2()
var attacking = false
var direction = 1
@onready var player = get_node("/root/Node2D/Player")
@export var bullet_scene = preload("res://bullet_flying_rat.tscn")
@export var bullet_damage = 5
@export var missile_damage = 3
@export var big_bomb_damage = 20


@onready var healthbar = get_node("/root/Node2D/CanvasLayer/ProgressBar")
@onready var cutscene = get_node("/root/Node2D/CanvasLayer2")
@onready var body = $body
@onready var Lcannon = $cannon_left
@onready var Rcannon = $cannon_right
@onready var main = $main_cannon
@onready var main_light = $main_cannon/PointLight2D
@onready var Lmissile = $missile_left
@onready var Rmissile = $missile_right
@onready var timer = $Timer
@onready var rocket = preload("res://rat_rocket.tscn")
@onready var bomb = preload("res://dynamite.tscn")
@onready var music = get_node("/root/Node2D/Player/RatKingSOUNDTRACK")

var can_attack = false
var active = false
var idle = true
var dead = false
var arena_node : Area2D
var hover_height = 0
var hover = false
var rotation_speed = 25
var rotation_offset = -PI / 2
var missiles_firing = false
var attack_type = 1
var cooldown_time = 1


func _ready():
	health = 100
	healthbar.init_health(health)
	main_light.enabled = false
	body.play("default")
	main.play("idle")
	Lcannon.play("aim")
	Rcannon.play("aim")
	can_attack = false



func _physics_process(delta: float) -> void:
	if player.position.x > position.x:
		direction = 1
	else:
		direction = -1
		
	var cannon_direction = player.global_position - global_position
	if cannon_direction.length() > 0:	
		var target_angle = cannon_direction.angle() + rotation_offset
		Rcannon.rotation = lerp_angle(Rcannon.rotation, target_angle, rotation_speed * delta)
		Lcannon.rotation = lerp_angle(Lcannon.rotation, target_angle, rotation_speed * delta)
	if not can_attack and active:
		overhead()
	elif can_attack and not dead:
		if attack_type == 1:
			cannons()
		elif attack_type == 2:
			missiles()
		elif attack_type == 3:
			drop_bombs()
		if attack_type > 3:
			attack_type = 1
	if direction == 1 and not hover :
		body.flip_h = true
		main.flip_h = true # Flip sprite horizontally to face left
	elif direction == -1 and not hover:
		body.flip_h = false
		main.flip_h = false  # Flip sprite horizontally to face right
	
	if not attacking and not dead:
		move_and_slide()

func drop_bombs():
	can_attack = false
	attack_type+=1
	velocity = Vector2(0,0)
	main.play("fire")
	await main.animation_finished
	main_light.enabled = true
	main.play("idle")
	var projectile = bomb.instantiate()
	projectile.position = position
	projectile.top_level = true
	add_child(projectile)
	main_light.enabled = false
	Lcannon.play("aim")
	Rcannon.play("aim")
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = cooldown_time
	timer.start()
	await timer.timeout
	can_attack = true

func missiles():
	can_attack = false
	attack_type+=1
	velocity = Vector2(0,0)
	missiles_firing = true
	Lmissile.play("active")
	Rmissile.play("active")
	await Lmissile.animation_finished
	
	
	Lmissile.play("fire")
	for i in 3:
		var projectile = rocket.instantiate()
		var attack_direction = (player.position - position).normalized()
		projectile.position.x -= 15
		projectile.rotation = attack_direction.angle()
		projectile.scale = Vector2(1,1)
		add_child(projectile)
		timer = Timer.new()
		add_child(timer)
		timer.wait_time = 0.3
		timer.start()
		await timer.timeout
		
	Rmissile.play("fire")	
	for i in 3:
		var projectile = rocket.instantiate()
		var attack_direction = (player.position - position).normalized()
		projectile.position.x += 15
		projectile.rotation = attack_direction.angle()
		projectile.scale = Vector2(1,1)
		add_child(projectile)
		timer = Timer.new()
		add_child(timer)
		timer.wait_time = 0.3
		timer.start()
		await timer.timeout
	
	Lmissile.play("deactive")
	Rmissile.play("deactive")
	missiles_firing = false
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = cooldown_time
	timer.start()
	await timer.timeout
	can_attack = true
	
	
	
	
func cannons():
	can_attack = false
	attack_type+=1
	Lcannon.play("fire")
	Rcannon.play("fire")
	var bullet = bullet_scene.instantiate()
	var bullet2 = bullet_scene.instantiate()
	bullet.position = position + Vector2(45, 20)
	bullet2.position = position - Vector2(45, -20)
	var bullet_direction = (player.position - position).normalized()
	bullet.rotation = bullet_direction.angle()
	bullet2.rotation = bullet_direction.angle()
	get_parent().add_child(bullet)
	get_parent().add_child(bullet2)
	
	
	await Lcannon.animation_finished
	Lcannon.play("idle")
	Rcannon.play("idle")
	
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = cooldown_time
	timer.start()
	await timer.timeout
	can_attack = true


func overhead():
	var target_pos = player.position - Vector2(0, 75)
	var target_direction = (target_pos - position).normalized()
	if position.distance_to(target_pos) > 10:
		velocity = target_direction * 50
		move_and_slide()
	elif position.distance_to(target_pos) <= 10:
		velocity.x = 0
		velocity.y = 0

	
func take_damage(damage):
	health -= damage
	healthbar.health = health
	if health <= 0:
		cutscene.boss_dead_yet = true
		healthbar.queue_free()
		die()
		
	
func die():
	active = false
	can_attack = false
	dead = true
	get_node("/root/Node2D/boss_arena/StaticBody2D/CollisionShape2D").set_deferred("disabled",true)
	get_node("/root/Node2D/boss_arena/StaticBody2D/Sprite2D").visible = false
	queue_free() 
	
