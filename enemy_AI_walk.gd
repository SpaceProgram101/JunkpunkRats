extends CharacterBody2D

@export var knockback_force = 200.0
@export var knockback_duration = 0.2

# Speed and direction variables
var speed = 100
var direction = 1  # 1 for moving right, -1 for moving left

# A variable to store the position of the original spawn point
var start_position = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	#$Area2D.connect("body_entered", Callable(self, "_on_body_entered"))
	#$Area2D.connect("area_entered", Callable(self, "_on_area_entered"))
	#set_meta("knockback", true)
	start_position = position  # Save the starting position
	$AnimatedSprite2D.play("walk")
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


# Knockback f1
func _on_body_entered(body):
	print("Collision detected with:", body.name)
	if body.has_method("apply_knockback"):
		print("Calling apply_knockback with position:", global_position)
		body.apply_knockback(knockback_force, knockback_duration, global_position)
	else:
		printerr("ERROR: Colliding body does not have 'apply_knockback' function")

#knockback f2
func _on_area_entered(area):
	if area.has_method("apply_knockback"):
		area.apply_knockback(knockback_force, knockback_duration, global_position)
	else:
		printerr("Colliding area does not have 'apply_knockback' function")
