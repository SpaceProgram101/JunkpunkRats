extends Area2D

signal attack_hit(body)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_AttackArea_body_entered(body):
	if body.is_in_group("enemies"):
		body.take_damage(10)
		emit_signal("attack_hit", body)
		print ("Hit an enemy!")
