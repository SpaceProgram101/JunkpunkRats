extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@export var health : int = 500
var start_position = Vector2()
var attacking = false
var direction = 1
@onready var player = get_node("/root/Node2D/Player")
@export var bullet_scene = preload("res://bullet_flying_rat.tscn")
@onready var body = $body
@onready var Lcannon = $cannon_left
@onready var Rcannon = $cannon_right
@onready var main = $main_cannon
@onready var Lmissile = $missile_left
@onready var Rmissile = $missile_right
@onready var timer = $Timer
@onready var rocket = preload("res://rat_rocket.tscn")
var can_attack = false
var idle = true
var dead = false
var arena_node : Area2D
var hover_height = 0
var hover = false
var rotation_speed = 25
var rotation_offset = -PI / 2
var missiles_firing = false

func _ready():
	body.play("default")
	
	var timer2 = Timer.new()
	add_child(timer2)
	timer2.wait_time = 5
	timer2.start()
	await timer2.timeout
	can_attack = true



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
	if not missiles_firing:
		overhead()
	if can_attack:
		missiles()
	if direction == 1 and not hover :
		body.flip_h = true
		main.flip_h = true # Flip sprite horizontally to face left
	elif direction == -1 and not hover:
		body.flip_h = false
		main.flip_h = false  # Flip sprite horizontally to face right
	
	if not attacking and not dead:
		move_and_slide()

func missiles():
	velocity = Vector2(0,0)
	missiles_firing = true
	can_attack = false
	print ("Missiles launched.")
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
		var timer = Timer.new()
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
		var timer = Timer.new()
		add_child(timer)
		timer.wait_time = 0.3
		timer.start()
		await timer.timeout
	
	Lmissile.play("deactive")
	Rmissile.play("deactive")
	missiles_firing = false
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = 3
	timer.start()
	await timer.timeout
	can_attack = true
	
	
	
	
func cannons():
	can_attack = false
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
	
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = 2
	timer.start()
	await timer.timeout
	can_attack = true


func overhead():
	var target_pos = player.position - Vector2(0, 75)
	var target_direction = (target_pos - position).normalized()
	if position.distance_to(target_pos) > 10:
		hover = false
		velocity = target_direction * 50
		move_and_slide()
	elif position.distance_to(target_pos) <= 10:
		velocity.y = 0
		hover = true


func attack(type : int):
	if type == 1:
		var target_pos = player.position + Vector2(75, 0)
		var target_direction = (target_pos - position).normalized()
		velocity = target_direction * 50
		move_and_slide()
		

func cooldown():
	can_attack = false
	timer.wait_time = 5.0
	timer.start()
	await timer.timeout
	can_attack = true
