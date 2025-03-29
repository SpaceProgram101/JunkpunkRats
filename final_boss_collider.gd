extends CharacterBody2D

var health = 3
var dead = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not dead:
		$AnimatedSprite2D.play("default")

func take_damage(damage : int):
	if not dead:
		health -= damage
		if health <= 0:
			die()
		
func die():
	if not dead:
		dead = true
		$AnimatedSprite2D.play("dead")
