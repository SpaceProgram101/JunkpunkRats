extends CharacterBody2D

var health = 100
var damage = 0
var dead = false
@onready var door = get_node("/root/Node2D/final_laser/StaticBody2D/CollisionShape2D")
@onready var monolith = get_node("/root/Node2D/final_arena/final_monolith")
@onready var rocket1 = get_node("/root/Node2D/final_arena/rocket_turret")
@onready var rocket2 = get_node("/root/Node2D/final_arena/rocket_turret2")
@onready var rocket3 = get_node("/root/Node2D/final_arena/rocket_turret3")
@onready var rocket4 = get_node("/root/Node2D/final_arena/rocket_turret4")
@onready var healthbar = get_node("/root/Node2D/CanvasLayer/Final_Bar2")
@onready var music = get_node("/root/Node2D/AudioStreamPlayer")
var r_health = 50
var m_health = 100
var c_health = 200
var immune = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	door.disabled = false
	r_health = rocket1.health + rocket2.health + rocket3.health + rocket4.health
	m_health = monolith.health
	health = c_health + m_health + r_health
	print(health)
	healthbar.init_health(health)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if not dead:
		$AnimatedSprite2D.play("default")
		r_health = rocket1.health + rocket2.health + rocket3.health + rocket4.health
		m_health = monolith.health
		health = c_health + m_health + r_health
		healthbar.health = health


func take_damage(damage : int):
	if not dead:
		c_health -= damage
		if health <= 0:
			die()
		
func die():
	if not dead:
		dead = true
		get_node("/root/Node2D/final_laser/Node2D").queue_free()
		get_node("/root/Node2D/final_laser/bossdoor1").queue_free()
		get_node("/root/Node2D/final_laser/StaticBody2D").queue_free()
		get_node("/root/Node2D/Lava").queue_free()
		get_node("/root/Node2D/final_laser/bossdoor2").queue_free()
		get_node("/root/Node2D/Floor_lava/door").rotation = 0
		get_node("/root/Node2D/Floor_lava/door_collision").rotation = 0
		music.stream = music.warning
		music.play()
		get_parent().dead = true
		$AnimatedSprite2D.play("dead")
