extends AnimatedSprite2D  # This script is attached to your AnimatedSprite2D node

@onready var timer: Timer = $Timer  # Reference to the Timer node
@onready var player = get_parent()  # Assuming the player is the parent of this effect node (or set to your player node directly)

# Duration of the "poof" animation (set manually based on your animation)
const POOF_ANIMATION_DURATION = 3.0  # Set this to the exact length of your "poof" animation

# Called every frame. Handles jump effect activation.
func _process(delta):
	# Detect when the spacebar is pressed (and the player is jumping)
	if Input.is_action_just_pressed("ui_accept"):  # "ui_accept" is spacebar by default
		trigger_jump_effect()

	# If the effect is invisible, make it follow the player
	if not visible:
		position = player.position + Vector2(0, 20)  # Adjust the Y offset to keep it at the player's feet

# Trigger the jump effect when the spacebar is pressed
func trigger_jump_effect():
	# Position the effect at the feet (relative to the character)
	position = player.position + Vector2(0, 20)  # Adjust Y offset to position it at the character's feet
	
	# Make sure the effect is visible
	visible = true
	
	# Play the animation (use your animation's name here, such as "poof")
	play("poof")
	
	# Start the timer using the manually defined duration of the animation
	timer.start(POOF_ANIMATION_DURATION)

# Timer's timeout signal to remove the effect after the animation ends
func _on_Timer_timeout():
	stop()  # Stop the animation if it's still playing
	visible = false  # Hide the effect after the animation finishes
	# Now it will start following the player again
