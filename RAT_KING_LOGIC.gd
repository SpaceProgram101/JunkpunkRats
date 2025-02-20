extends StaticBody2D

@onready var controller = get_node("Head")
@onready var breakable = get_node("platform_break_RATKING")
@onready var breakable_collider = get_node("platform_break_RATKING/CollisionShape2D")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	 # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if controller.music_played_before:
		breakable.visible = false
		breakable_collider.disabled = true
