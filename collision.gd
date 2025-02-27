extends Area2D
@onready var player = get_parent()
@onready var immune = get_parent().immune
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_body_entered(body: Node2D) -> void:
	if not immune:
		if body.is_in_group("enemy_projectile"):
			player.take_damage(1)
			body.dead = true
			body.sprite.play("death")
			await body.sprite.animation_finished
			body.queue_free()
			print ("Bullet SHOULD have been deleted")
		elif body.is_in_group("enemies"):
			player.take_damage(1)
		
		
