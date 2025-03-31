extends Node

var has_cutscene_played = false  # This resets when the game restarts
var boss_spawned_yet = false
var boss_dead_yet = false
var entering = false
var entered = false
@onready var player = get_node("/root/Node2D/Player")
@onready var theFnafMovie = $VideoStreamPlayer
@onready var boss = get_node("/root/Node2D/helicopter_boss")
var voicelines : Array = [
	preload("res://cutscene_but_real.ogv"),
	preload("res://boss_death_cutscene.ogv"),
	preload("res://boss_intro_cutscene.ogv"),
	preload("res://title_screen/final_boss_entry.ogv"),
	preload("res://title_screen/final_boss_entry.ogv")
]

func _ready():
	theFnafMovie.stream = voicelines[0]
	player.frozen = true
	theFnafMovie.play()
	await theFnafMovie.finished
	player.frozen = false
	
func _input(event):
	if event.is_action_pressed("ui_accept"):
		theFnafMovie.stop()
		player.frozen = false
		if theFnafMovie.stream == voicelines[2] and not boss_spawned_yet:
			start_boss_battle()
		if theFnafMovie.stream == voicelines[3] and not entered:
			player.position = Vector2(14260, -5144)
			entered = true

func _process(_delta):
	if boss_dead_yet:
		death()
		boss_dead_yet = false
	if entering:
		entering = false
		theFnafMovie.stream = voicelines[3]
		theFnafMovie.play()
		player.frozen = true
		await theFnafMovie.finished
		entered = true
		player.position = Vector2(14260, -5144)
		player.frozen = false

func death():
	theFnafMovie.stream = voicelines[1]
	theFnafMovie.play()
	player.frozen = true
	
	
func _on_boss_arena_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and not boss_spawned_yet:
		theFnafMovie.stream = voicelines[2]
		theFnafMovie.play()
		player.frozen = true
		await theFnafMovie.finished
		start_boss_battle()


func start_boss_battle():
	get_node("/root/Node2D/Player/RatKingSOUNDTRACK").gamestate = 1
	get_node("/root/Node2D/Player/RatKingSOUNDTRACK").play()
	boss_spawned_yet = true
	boss.can_attack = false
	player.frozen = false
	boss.can_attack = true
	boss.active = true
