extends Area2D

var leave = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if not leave:
		$AnimatedSprite2D.play("default")
	if Input.is_action_just_pressed("interact"):
		if leave:
			get_tree().change_scene_to_file("res://end.tscn")


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		$AnimatedSprite2D.play("highlight")
		leave = true


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		$AnimatedSprite2D.play("default")
		leave = false
