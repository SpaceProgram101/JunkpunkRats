extends Area2D
@onready var player = get_node("/root/Node2D/Player")
@export var symbol_1 : Texture
@export var symbol_2 : Texture

@export var active : Texture
@export var deactive : Texture

var tween : Tween

var is_near_player : bool = false
var symbol_shown = false

@onready var sprite = $Sprite2D
@onready var symbol_1_display = $Symbol1
@onready var symbol_2_display = $Symbol2



var fade_time : float = 1.0
var fade_timer : float = 0.0
var is_fading_in : bool = false
var is_fading_out : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	symbol_1_display.visible = false
	symbol_2_display.visible = false
	symbol_1_display.modulate.a = 0.0
	symbol_2_display.modulate.a = 0.0	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_fading_in:
		fade_timer += delta
		if fade_timer >= fade_time:
			fade_timer = fade_timer
			is_fading_in = false
		symbol_1_display.modulate.a = (fade_timer / fade_time) + 3
		symbol_2_display.modulate.a = (fade_timer / fade_time) + 3
	elif is_fading_out:
		fade_timer += delta
		if fade_timer >= fade_time:
			fade_timer = fade_timer
			is_fading_out = false
		symbol_1_display.modulate.a = 1 - (fade_timer / fade_time)
		symbol_2_display.modulate.a = 1 - (fade_timer / fade_time)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		sprite.texture = active
		is_near_player = true
		show_symbols()
		
func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		sprite.texture = deactive
		is_near_player = false
		hide_symbols()

		
func show_symbols():
	if not symbol_shown:
		sprite.modulate.a = 2
		$AudioStreamPlayer2D.play()
		symbol_1_display.texture = symbol_1
		symbol_2_display.texture = symbol_2
		
		symbol_1_display.visible = true
		symbol_2_display.visible = true
		
		fade_timer = 0.0
		is_fading_in = true
		symbol_shown = true
		
func hide_symbols():
	if symbol_shown:
		symbol_1_display.modulate.a = 1
		symbol_2_display.modulate.a = 1
		sprite.modulate.a = 1
		fade_timer = 0.0
		is_fading_out = true
		
		symbol_shown = false
