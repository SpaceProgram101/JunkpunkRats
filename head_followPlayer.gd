extends AnimatedSprite2D
@onready var player = get_node("/root/Node2D/Player")

var rotation_speed = 1.0
var rotation_offset = -PI / 2
var awake = false
var music_played_before = false
var waking = false
var king_position = global_transform.origin
@onready var music_player = get_node("/root/Node2D/TheRatKing/AudioStreamPlayer2D")
@onready var timer : Timer

func _ready():
	play("asleep")
	timer = $/root/Node2D/TheRatKing/Timer
	$PointLight2D.enabled = false
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player.position.distance_to(king_position) >= 1600:
		if not awake:
			print ("Timer started.")
			timer.start(5)
			awake = true
			await timer.timeout
			wake_up()
			
			
	
	
	if awake and music_played_before:
		var direction = player.global_position - global_position
	# Calculate the angle in radians between the sprite and the player
		if direction.length() > 0:	
			var target_angle = direction.angle() + rotation_offset
	# 	Set the sprite's rotation to the calculated angle
			rotation = lerp_angle(rotation, target_angle, rotation_speed * delta)
			
			print ("Playing music!")
			

	


func wake_up():
	awake = true
	music_played_before = true
	$PointLight2D.enabled = true
	play("awake")
	if not music_player.playing:
		music_player.play()
	
	
	
