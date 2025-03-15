extends Node2D

@onready var arena = preload("res://arena.tscn")
@export var warrior : int
@export var helicopter : int
@export var staff : int
@export var rocket : int
@export var arenatype : int
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var spawn = arena.instantiate()
	spawn.warrior = warrior
	spawn.helicopter = helicopter
	spawn.staff = staff
	spawn.rocket = rocket
	spawn.arenatype = arenatype
	spawn.arena_progress = 0
	spawn.arena_max = warrior + helicopter + staff + rocket
	add_child(spawn)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
