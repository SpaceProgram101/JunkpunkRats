extends Sprite2D

var size = 0.05
var dead = false
var fade_timer = 0.0
var fade_time = 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	dead = false
	modulate.a = 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position = get_parent().position
	fade_timer += delta
	modulate.a = 1 - (fade_timer / fade_time)
	scale += Vector2(size, size) / 10
	if fade_timer >= fade_time or modulate.a <= 0:
		fade_timer = 1.0
		dead = true
		queue_free()
