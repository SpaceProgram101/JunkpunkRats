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
var r_health = 40
var m_health = 20
var c_health = 40


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	door.disabled = false
	r_health = rocket1.health + rocket2.health + rocket3.health + rocket4.health
	m_health = monolith.health
	health = c_health + m_health + r_health
	healthbar.init_health(health)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	print("Total: ", health)
	print("monolith: ", m_health)
	print("Rocket: ", r_health)
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
		get_node("/root/Node2D/final_laser/StaticBody2D").queue_free()
		get_node("/root/Node2D/Lava").queue_free()
		get_node("/root/Node2D/final_laser/StaticBody2D2").queue_free()
		get_node("/root/Node2D/Floor_lava/door").rotation = 0
		get_node("/root/Node2D/Floor_lava/door_collision").rotation = 0
		get_parent().dead = true
		$AnimatedSprite2D.play("dead")
