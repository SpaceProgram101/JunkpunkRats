extends Area2D

@onready var full = $FullShrine
@onready var used = $UsedShrine
@onready var player = null
var usedUp = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("body_entered", Callable(self, "_on_body_entered"))
	full.show()
	used.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (usedUp):
		used.show()
		full.hide()
	


func _on_body_entered(body):
	if body.is_in_group("player"):
		player = body


func _input(event):
	if event.is_action_pressed("interact") and player and !usedUp:
		player.heal(1)
		usedUp = true
		
