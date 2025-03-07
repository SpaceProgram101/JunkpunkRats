extends Area2D

@onready var full = $FullShrine
@onready var player = null
var usedUp = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))
	full.play("active")
	$PointLight2D.enabled = true
	$PointLight2D.energy = 3.5


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if (usedUp):
		$PointLight2D.enabled = false
		full.play("deactive")
	


func _on_body_entered(body):
	if body.is_in_group("player"):
		$PointLight2D.energy = 10
		player = body
		
func _on_body_exited(body):
	if body.is_in_group("player"):
		$PointLight2D.energy = 3.5
		player = body



func _input(event):
	if event.is_action_pressed("interact") and player and !usedUp:
		full.play("consume")
		await full.animation_finished
		$PointLight2D.energy = 3.5
		player.heal(1)
		print ("Healed the player.")
		usedUp = true
		
