extends Area2D

@onready var full = $Sprite2D
@onready var symbol_light = $symbol/PointLight2D
@onready var symbol = $symbol
@onready var player = null
var usedUp = false


var fade_time : float = 1.0
var fade_timer : float = 0.0
var is_fading_in : bool = false
var is_fading_out : bool = false
var symbol_shown = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))
	full.visible = true
	symbol_shown = false
	symbol.visible = false
	is_fading_in = false
	is_fading_out = false
	symbol.modulate.a = 0.0
	symbol_light.enabled = false
	$PointLight2D.enabled = true
	$PointLight2D.energy = 1




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (usedUp):
		$PointLight2D.enabled = false
		full.visible = false
	if is_fading_in:
		fade_timer += delta
		if fade_timer >= fade_time:
			fade_timer = fade_timer
			is_fading_in = false
			is_fading_out = true
		symbol.modulate.a = (fade_timer / fade_time)
	elif is_fading_out:
		fade_timer += delta
		if fade_timer >= fade_time:
			fade_timer = fade_timer
			symbol.visible = false
			is_fading_out = false
		symbol.modulate.a = 1 - (fade_timer / fade_time)
	


func _on_body_entered(body):
	if body.is_in_group("player"):
		$PointLight2D.energy = 3.5
		player = body
		
func _on_body_exited(body):
	if body.is_in_group("player"):
		$PointLight2D.energy = 1
		player = null



func _input(event):
	if event.is_action_pressed("interact") and player and !usedUp:
		symbol_light.enabled = true
		$PointLight2D.energy = 3.5
		if not symbol_shown:
			print ("Attempting to fade in...")
			symbol.visible = true
			fade_timer = 0.0
			is_fading_in = true
			symbol_shown = true
		usedUp = true
