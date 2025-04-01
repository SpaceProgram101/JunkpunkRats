extends Area2D

var phase1 = false
var phase2 = false
var arenacomplete1 = false
var player_in_arena = false
@onready var player_audio = get_node("/root/Node2D/AudioStreamPlayer")
@onready var stickrat = preload("res://rat_stick.tscn")
@onready var flyrat = preload("res://flying_rat.tscn")
@onready var staffrat = preload("res://rat_staff.tscn")
@onready var rocketrat = preload("res://rat_rocketeer.tscn")
@onready var player = get_node("/root/Node2D/Player")
@onready var monolith = $final_monolith
@onready var timer = $Timer
var enemytype = 1
var can_spawn = false
var active = false
var rocketcount = 5


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	phase1 = false
	phase2 = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if rocketcount > 0 and player_in_arena:
		phase1 = true
	if rocketcount <= 0:
		get_node("/root/Node2D/Floor_lava").open_door()
		player_in_arena = false
		rocketcount = 1
		phase2 = true
		phase1 = false	
	if get_node("/root/Node2D/Floor_lava").open:
		get_node("/root/Node2D/Lava").can_rise = true
		get_node("/root/Node2D/Camera2D").cutscene = true
		player.frozen = true
		player.position = Vector2(14260, -5144)
	elif not get_node("/root/Node2D/Floor_lava").open:
		player.frozen = false
		get_node("/root/Node2D/Camera2D").cutscene = false
		get_node("/root/Node2D/Floor_lava").open = false
		
		
		
func _on_timer_timeout():
	can_spawn = false
	
					
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_arena = true
		
