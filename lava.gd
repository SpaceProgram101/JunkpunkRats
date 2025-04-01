extends Area2D

@onready var player = get_node("/root/Node2D/Player")
var can_rise = false
var cutscene = true
var touching_player = false
var cinema = true
var damage = 15
var stop_big_lava = false
var stop_pos = Vector2(0,0)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("lava") 
	can_rise = false
	$AnimatedSprite2D.visible = true
	$AnimatedSprite2D2.visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if position.y < -5000:
		if not stop_big_lava:
			stop_big_lava = true
			stop_pos = $AnimatedSprite2D.global_position
		$AnimatedSprite2D.global_position = stop_pos
	if can_rise:
		if cinema and cutscene:	
			cutscene = false
			var timer = $lava_delay
			timer.one_shot = true
			timer.start()
			await timer.timeout
			cinema = false
		if not cinema:
			position.y -= 0.3
	if player.dead:
		position.y = -5000		


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		touching_player = true
		body.take_damage(15)
		print("ballsack")


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		touching_player = false


func _on_stop_lava_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		can_rise = false
