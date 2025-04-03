extends Area2D

@onready var full = $FullShrine
@onready var light = $FullShrine/PointLight2D
@onready var player = null
var usedUp = false
var respawn_position: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position.y += 10
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))
	full.play("active")
	light.enabled = true
	light.energy = 3.5
	respawn_position = position



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if (usedUp):
		light.enabled = false
		full.play("deactive")
	


func _on_body_entered(body):
	if body.is_in_group("player"):
		light.energy = 4
		player = body
		
func _on_body_exited(body):
	if body.is_in_group("player"):
		light.energy = 2
		player = null



func _input(event):
	if event.is_action_pressed("interact") and player and !usedUp:
		$AudioStreamPlayer2D.play()
		player.set_respawn_point(position)
		full.play("consume")
		await full.animation_finished
		light.energy = 4
		if not player.skibidi >= 100:
			player.heal(50)
		print ("Healed the player.")
		usedUp = true
		
		respawn_position = player.position
		
		print("Setting respawn point:", respawn_position)
		if player:
			player.set_respawn_point(respawn_position)
		else:
			print("Error: Player is null!")
		
