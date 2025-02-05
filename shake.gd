extends Camera2D

# Parameters for the shake
var shake_intensity = 200  # How strong the shake is (in pixels)
var shake_duration = 0.3  # How long the shake lasts (in seconds)

# Internal variables to handle the shake
var shake_timer = 0.0
var shake_offset = Vector2.ZERO
var original_offset = Vector2(0, -75)

func _process(delta):
	if shake_timer > 0:
		shake_timer -= delta  # Decrease timer as time passes
		
		# Randomly adjust the camera's position within the shake intensity
		shake_offset = Vector2(randf_range(-shake_intensity, shake_intensity), randf_range(-shake_intensity, shake_intensity))
		offset = shake_offset
	else:
		# Reset shake
		shake_offset = Vector2.ZERO
	offset = shake_offset + original_offset


# Call this function when you want to trigger the shake
func shake(intensity, duration):
	shake_intensity = intensity
	shake_duration = duration
	shake_timer = shake_duration
