extends AnimatedSprite2D
@onready var player = get_node("/root/Node2D/Player")
@onready var boss = get_parent()
@onready var phase = 0;

var rotation_speed = 3.0
var rotation_offset = -PI / 2
var awake = false
var music_played_before = false
var waking = false

@onready var music_player = get_node("/root/Node2D/TheRatKing/AudioStreamPlayer2D")

@onready var timer : Timer
var musicPhase : Array = [
	preload("res://0-1RK.mp3"),
	preload("res://1-2RK.mp3"),
	preload("res://2-3RK.mp3"),
	preload("res://3-4RK.mp3"),
	preload("res://FINAL_RK.mp3"),
	preload("res://INTERMISSION_RK.mp3"),
]



func _ready():
	play("asleep")
	timer = $/root/Node2D/TheRatKing/Timer
	$PointLight2D.enabled = false
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var boss_pos = boss.position
	if Input.is_action_just_pressed("Toggle Phase Up"):
		phase += 1
		music_player.stop()
		music_player.stream = musicPhase[phase]
		music_player.play()
	elif Input.is_action_just_pressed("Toggle Phase Down"):
		phase -= 1
		music_player.stop()
		music_player.stream = musicPhase[phase]
		music_player.play()
	if player.position.distance_to(boss_pos) <= 300:
		if not awake:
			awake = true
			timer.start(5)
			await timer.timeout
			wake_up()
			
			
	
	
	if awake and music_played_before:
		var direction = player.global_position - global_position
	# Calculate the angle in radians between the sprite and the player
		if direction.length() > 0:	
			var target_angle = direction.angle() + rotation_offset
	# 	Set the sprite's rotation to the calculated angle
			rotation = lerp_angle(rotation, target_angle, rotation_speed * delta)
			
			

	


func wake_up():
	music_played_before = true
	$PointLight2D.enabled = true
	play("awake")
	if not music_player.playing:
		awake = true
		music_player.stream = musicPhase[phase]
		music_player.play()
	
	
	
