extends Area2D

var speed = 800  # Speed of the projectile
var rotation_speed = 3  # How fast the projectile rotates (degrees per second)  
var cog_gravity = 500 # Gravity force that pulls the projectile downwards
var gravity_delay = 0.2
var time_in_air = 0
var proj_life = 0.5

var min_size = 0.1
var max_size = 1.0

func _ready():
	# Optionally add a visual or sprite for the projectile
	# e.g., preload a texture
	var sprite = $Sprite2D
	sprite.texture = preload("res://cog1.png")
	
	var random_scale = randf_range(min_size, max_size)
	scale = Vector2(random_scale, random_scale)
	
	var timer = get_tree().create_timer(proj_life)

	await timer.timeout
	
	queue_free()

func _process(delta):
	# Move the projectile forward in its current direction
	
	var direction = Vector2(cos(rotation), sin(rotation))  # Move based on rotation
	position += direction * speed * delta
	
	time_in_air += delta
	if time_in_air > gravity_delay:
		position.y += cog_gravity * delta

	# Apply gravity to simulate falling

	# Apply rotation over time for the spinning effect
	rotation += rotation_speed * delta
