extends Area2D

@onready var full = $FullShrine
@onready var player = null
var usedUp = false
var respawn_position: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))
	full.play("active")
	$PointLight2D.enabled = true
	$PointLight2D.energy = 3.5
	respawn_position = position



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
		player = null



func _input(event):
	if event.is_action_pressed("interact") and player and !usedUp:
		player.set_respawn_point(position)
		full.play("consume")
		await full.animation_finished
		$PointLight2D.energy = 3.5
		player.heal(50)
		print ("Healed the player.")
		usedUp = true
		
		respawn_position = player.position
		
		print("Setting respawn point:", respawn_position)
		if player:
			player.set_respawn_point(respawn_position)
		else:
			print("Error: Player is null!")
		
