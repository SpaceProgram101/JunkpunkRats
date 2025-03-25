extends Area2D

@onready var player = get_node("/root/Node2D/Player")
var can_rise = false
var touching_player = false
var damage = 15
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	can_rise = player.kms
	if can_rise:
		position.y -= 0.2


func _on_body_entered(body: Node2D) -> void:
	touching_player = true


func _on_body_exited(body: Node2D) -> void:
	touching_player = false
