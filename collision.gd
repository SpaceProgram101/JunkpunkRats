extends Area2D
@onready var player = get_parent()
@onready var immune = get_parent().immune
@onready var dynamite = preload("res://dynamite.tscn")
@onready var healthbar = get_node("/root/Node2D/CanvasLayer/PlayerBar")
var in_radius = false
var exploding = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	immune = get_parent().immune
	if in_radius and exploding and not immune:
			player.take_damage(3)
			in_radius = false



func _on_body_entered(body: Node2D) -> void:
	immune = get_parent().immune
	if body.is_in_group("enemy_projectile"):
		body.dead = true
	if not immune:
		if body.is_in_group("enemy_projectile"):
			player.take_damage(body.damage)
			body.dead = true
		elif body.is_in_group("enemies"):
			player.take_damage(5)
		elif body.is_in_group("bounce bounce"):
			$/root/Node2D/Player/AnimatedSprite2D.play("jump")
			$/root/Node2D/BounceBounce/Sprite2D.play("boing")
			$/root/Node2D/Player/Jump.play()
			player.velocity.y = player.JUMP_VELOCITY*2
			$/root/Node2D/Player/AudioBoing.play()
			await $/root/Node2D/BounceBounce/Sprite2D.animation_finished
			$/root/Node2D/BounceBounce/Sprite2D.play("idle")
		


func _on_area_entered(area: Area2D) -> void:
	immune = get_parent().immune
	
	if not immune:
		if area.is_in_group("hurt_walls"):
			player.take_damage(15)
