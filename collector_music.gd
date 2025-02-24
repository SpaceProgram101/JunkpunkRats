extends AudioStreamPlayer2D

@export var fade_duration: float = 3.0  # Duration for fade-in effect
@export var distance: float = 200.0  # Maximum distance at which music fades in fully
var target_volume: float = 0.0  # Final volume when the player is at maximum proximity
var start_volume: float = -80.0  # Silent starting volume
var fade_timer: float = 0.0  # Tracks time spent fading in
@export var player: CharacterBody2D  # The player node, make sure it's assigned or detected

func _ready():
	# Automatically assign the player if it's not already assigned
	if not player:
		player = get_parent().get_node("Node2D/Player")  # Replace "Player" with your actual player node path
	else:
		stream.loop = true
		play()
		volume_db = start_volume  # Set the initial volume to silent

#func _process(delta: float) -> void:
	# Get the distance between the player and the NPC
	#var distance_to_player = global_position.distance_to(player.global_position)

	# Calculate how much of the fade-in effect should occur based on the distance
	#if distance_to_player < max_distance:
		#var fade_progress = 1.0 - (distance_to_player / max_distance)  # Fade progress (0 to 1)
		#fade_progress = clamp(fade_progress, 0.0, 1.0)  # Make sure the progress is between 0 and 1

		#target_volume = lerp(start_volume, 0.0, fade_progress)
	#else:
		# If the player is far enough away, set volume to silent
		#target_volume = start_volume

	# Smoothly update the volume towards target volume using lerp
	#volume_db = lerp(volume_db, target_volume, delta / fade_duration)
