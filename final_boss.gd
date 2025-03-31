extends Node2D

@onready var sprite = $Sprite2D
@onready var player = get_node("/root/Node2D/Player")
@onready var missiles = preload("res://rat_rocket.tscn")
@onready var dropper = preload("res://dropper.tscn")
@onready var background = get_node("/root/Node2D/Camera2D/ParallaxBackground/hell_backgrouind")
@onready var player_audio = get_node("/root/Node2D/Player/RatKingSOUNDTRACK")
@onready var roar = $AudioStreamPlayer2D
@onready var timer = $Timer
var attacktype = 0
var attack_timer = 0.0
var attack_cooldown = 3.0
var active = false
var attacking = false
var can_spawn = true
var entering_body = false 
var wake_up = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	attack_timer = 0.0
	attack_cooldown = 3.0
	sprite.play("asleep")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("interact") and entering_body:
		get_node("/root/Node2D/CanvasLayer2").entering = true
		entering_body = false
		player.frozen = true
	if active:
		if not attacking and can_spawn:
			attacking = true
			spawn_dropper()
	if wake_up:
		wake_up = false
		sprite.play("wake_up")
		roar.play()
		player_audio.chased = true
		await sprite.animation_finished
		$PointLight2D.active = true
		active = true
		can_spawn = true
		sprite.play("default")
		
func spawn_dropper():
	can_spawn = false
	sprite.play("drop_prep")
	await sprite.animation_finished
	sprite.play("drop_fire")
	await sprite.animation_finished
	var spawn = dropper.instantiate()
	get_parent().add_child(spawn)
	spawn.global_position = global_position + Vector2(randi_range(-20,20), -150)
	timer.wait_time = 2.0
	timer.start()
	await timer.timeout
	attacking = false


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		active = true
		wake_up = true
		background.visible = true



func _on_area_2d_2_body_entered(body: Node2D) -> void:
	active = false
	$Area2D2/Cannon.play("select")
	if body.is_in_group("player"):
		entering_body = true
