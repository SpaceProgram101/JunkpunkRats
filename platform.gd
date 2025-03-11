extends CharacterBody2D

var origin = position
var speed = 30
var direction = 1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	origin = position
	$AnimatedSprite2D.play("default")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# Move the enemy back and forth
	velocity.x = speed * direction 
	move_and_slide()
	
	# Update position based on velocity
	if direction == -1:
		$AnimatedSprite2D.flip_h = false  # Flip sprite horizontally to face left
	elif direction == 1:
		$AnimatedSprite2D.flip_h = true  # Flip sprite horizontally to face right

	# Flip direction when reaching a certain distance
	if position.x > origin.x + 115:  # Move right 200 pixels from start position
		direction = -1  # Move left
	elif position.x < origin.x - 115:  # Move left 200 pixels from start position
		direction = 1  # Move right
