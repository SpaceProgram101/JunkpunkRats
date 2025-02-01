extends Area2D

var speed = 300
var direction = Vector2()


func _process(delta):
	$AnimatedSprite2D.play("fireball")
	position += direction * speed * delta


func set_direction(target_position: Vector2):
	direction = (target_position - position).normalized()
	
	rotation = direction.angle()
