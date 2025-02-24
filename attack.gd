extends Area2D

signal attack_hit(body)


func _ready() -> void:
	pass 

func _process(_delta: float) -> void:
	pass

func _on_AttackArea_body_entered(body):
	#if the area entered is in the enemy group, that enemy group will take damage.
	if body.is_in_group("enemies"):
		body.take_damage(10)
		emit_signal("attack_hit", body)
		print ("Hit an enemy!")
