extends Area2D

var phase1 = false
var phase2 = false
var arenacomplete1 = false
var player_in_arena = false

@onready var stickrat = preload("res://rat_stick.tscn")
@onready var flyrat = preload("res://flying_rat.tscn")
@onready var staffrat = preload("res://rat_staff.tscn")
@onready var rocketrat = preload("res://rat_rocketeer.tscn")
@onready var monolith = $final_monolith
@onready var timer = $Timer
var enemytype = 1
var can_spawn = false
var active = false
var rocketcount = 4


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	phase1 = false
	phase2 = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not phase1 and not phase2 and player_in_arena:
		phase1 = true
			

func _on_timer_timeout():
	can_spawn = false
	
					
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_arena = true
		
