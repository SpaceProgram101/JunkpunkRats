extends Node2D

@onready var arena = preload("res://arena.tscn")
@onready var player = get_node("/root/Node2D/Player")
@export var warrior : int
@export var helicopter : int
@export var staff : int
@export var rocket : int
@export var arenatype : int
var respawn = false
var spawn
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn = arena.instantiate()
	spawn.warrior = warrior
	spawn.helicopter = helicopter
	spawn.staff = staff
	spawn.rocket = rocket
	spawn.arenatype = arenatype
	spawn.arena_progress = 0
	spawn.arena_max = warrior + helicopter + staff + rocket
	add_child(spawn)
	
func reset_arena():
	spawn.queue_free()
	spawn = arena.instantiate()
	spawn.warrior = warrior
	spawn.helicopter = helicopter
	spawn.staff = staff
	spawn.rocket = rocket
	spawn.arenatype = arenatype
	spawn.arena_progress = 0
	spawn.arena_max = warrior + helicopter + staff + rocket
	add_child(spawn)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if spawn != null:
		if spawn.arena_started_yet and player.dead:
			if not respawn:
				if not player.dead:
					respawn = true
					reset_arena()
