extends AnimatedSprite2D


var fade_timer = 0.0
var fade_time = 2.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	modulate.a = 1



func _process(delta):
	fade_timer += delta
	if fade_timer >= fade_time:
		fade_timer = fade_timer
	modulate.a = 1 - (fade_timer / fade_time)
