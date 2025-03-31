extends CharacterBody2D

var health = 3
var damage = 0
var dead = false
@onready var door = get_node("/root/Node2D/final_laser/StaticBody2D/CollisionShape2D")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	door.disabled = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
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
		get_node("/root/Node2D/final_laser/Node2D").visible = false
		get_node("/root/Node2D/final_laser/StaticBody2D/Door2-1_png").visible = false
		door.set_deferred("disabled",true)
		get_parent().dead = true
		$AnimatedSprite2D.play("dead")
