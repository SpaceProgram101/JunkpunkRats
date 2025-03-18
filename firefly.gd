extends Sprite2D

var fade_time = 5.0
var fade_timer = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if fade_timer < fade_time:
		fade_timer += delta
	modulate.a = (fade_timer / fade_time) * 255
	if fade_timer >= fade_time:
		queue_free()
