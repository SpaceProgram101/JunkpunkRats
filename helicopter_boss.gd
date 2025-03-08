extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@export var health : int = 500
var start_position = Vector2()
var attacking = false
var direction = 1
@onready var player = get_node("/root/Node2D/Player")
@onready var bullet_scene = preload("res://bullet_flying_rat.tscn")

@onready var body = $body
@onready var Lcannon = $cannon_left
@onready var Rcannon = $cannon_right
@onready var main = $main_cannon
@onready var Lmissile = $missile_left
@onready var Rmissile = $missile_right
@onready var timer = $Timer
var can_attack = true
var idle = true
var dead = false
var arena_node : Area2D
var hover_height = 0
var hover = false







func _physics_process(delta: float) -> void:
	if can_attack:
		attack(1)
	if direction == -1:
		body.flip_h = true # Flip sprite horizontally to face left
	elif direction == 1:
		body.flip_h = false  # Flip sprite horizontally to face right
	
	if not attacking and not dead:
		move_and_slide()


func attack(type : int):
	if type == 1:
		var target_pos = player.position + Vector2(100, 0)
		var target_direction = (target_pos - position).normalized()
		velocity = target_direction * 50
		move_and_slide()
		

func cooldown():
	can_attack = false
	timer.wait_time = 5.0
	timer.start()
	await timer.timeout
	can_attack = true
