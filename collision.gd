extends Area2D
@onready var player = get_parent()
@onready var immune = get_parent().immune
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
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
		elif body.is_in_group("bounce bounce"):
			$/root/Node2D/Player/AnimatedSprite2D.play("jump")
			$/root/Node2D/BounceBounce/Sprite2D.play("boing")
			$/root/Node2D/Player/Jump.play()
			player.velocity.y = player.JUMP_VELOCITY*2
			$/root/Node2D/Player/AudioBoing.play()
			await $/root/Node2D/BounceBounce/Sprite2D.animation_finished
			$/root/Node2D/BounceBounce/Sprite2D.play("idle")
		
