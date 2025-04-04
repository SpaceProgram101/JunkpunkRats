extends Area2D

@onready var player = get_node("/root/Node2D/Player")
@onready var cannon = get_node("/root/Node2D/Cannon")
var can_give = false

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and can_give:
		$AudioStreamPlayer2D.play()
		cannon.cooldown = .2
		get_node("/root/Node2D/boss_arena/StaticBody2D/CollisionShape2D").set_deferred("disabled",true)
		get_node("/root/Node2D/boss_arena/StaticBody2D/Sprite2D").visible = false
		await $AudioStreamPlayer2D.finished
		queue_free()
