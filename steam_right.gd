extends Area2D

@onready var boss = get_node("/root/Node2D/final_laser/final_boss_collider")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and boss.dead:
		$AudioStreamPlayer2D.pitch_scale += randf_range(-1,1)
		$Node2D.emitting = true
		$AudioStreamPlayer2D.play()
		await $Node2D.finished
		queue_free()
