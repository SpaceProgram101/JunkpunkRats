extends Area2D

@onready var leaves = get_node("/root/Node2D/Camera2D/ParallaxBackground/ParticlesLeaves")
@onready var snow = get_node("/root/Node2D/Camera2D/ParallaxBackground/ParticlesSnow")
@onready var fire = get_node("/root/Node2D/Camera2D/ParallaxBackground/ParticlesFire")
@onready var background = get_node("/root/Node2D/Camera2D/ParallaxBackground/snow_background")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		leaves.emitting = false
		snow.emitting = true
		background.visible = true
