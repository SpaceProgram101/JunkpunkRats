extends CharacterBody2D

# Speed and direction variables
var speed = 100
var direction = 1  # 1 for moving right, -1 for moving left

# A variable to store the position of the original spawn point
var start_position = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	start_position = position  # Save the starting position
	$AnimatedSprite2D.play("walk")  # Play the walking animation (replace with your animation name)

# Called every frame
func _process(delta):
	# Move the enemy back and forth
	position.x += speed * direction * delta
	
	# Update position based on velocity
	move_and_slide()
	
	# Flip sprite based on direction
	if direction == -1:
		$AnimatedSprite2D.flip_h = false  # Flip sprite horizontally to face left
	elif direction == 1:
		$AnimatedSprite2D.flip_h = true  # Flip sprite horizontally to face right

	# Flip direction when reaching a certain distance
	if position.x > start_position.x + 200:  # Move right 200 pixels from start position
		direction = -1  # Move left
	elif position.x < start_position.x - 200:  # Move left 200 pixels from start position
		direction = 1  # Move right
