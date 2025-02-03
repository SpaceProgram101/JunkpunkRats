extends Area2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var player = null
@onready var interaction_range = $CollisionShape2D
@onready var text_bubble = $text_bubble
var is_awake = false
var talking_animation_left = "talking_left"
var talking_animation_right = "talking_right"
var sleep_animation = "asleep"
var wake_up_animation = "waking up"
var current_animation = sleep_animation
var music_player: AudioStreamPlayer2D

var sleep_distance = 300
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text_bubble.visible = false
	connect("body_entered",Callable(self,"_on_body_entered"))
	connect("body_exited",Callable(self,"_on_body_exited"))
	animated_sprite.play("asleep")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if is_awake:
		if player and position.distance_to(player.position) > sleep_distance:
			go_to_sleep()
		elif player and position.distance_to(player.position) <= sleep_distance:
			if player.position.x > position.x:
				if current_animation != talking_animation_right:
					play_talking_animation(talking_animation_right)
			else:
				if current_animation != talking_animation_left:
						play_talking_animation(talking_animation_left)


func _on_body_entered(body):
	if body.is_in_group("player"):
		player = body

func _on_body_exited(_body):
	if is_awake:
		go_to_sleep()
	player = null
		
func wake_up():
	if not is_awake:
		current_animation = wake_up_animation
		animated_sprite.play(current_animation)
		await animated_sprite.animation_finished
		text_bubble.visible = true
		is_awake = true
		change_bubble()
		play_talking_animation()
		
		
func change_bubble():
	if is_awake:
		while is_awake:
			$text_bubble.play("rat")
			await $text_bubble.animation_finished
			$text_bubble.play("scrap")
			await $text_bubble.animation_finished

func play_talking_animation(anim = null):
	if anim:
		current_animation = anim
	elif player and player.position.x < position.x:
		current_animation = talking_animation_left
	else:
		current_animation = talking_animation_right
	
	animated_sprite.play(current_animation)
	
func go_to_sleep():
	is_awake = false
	text_bubble.visible = false
	animated_sprite.play("fall_asleep")
	await animated_sprite.animation_finished
	current_animation = sleep_animation
	animated_sprite.play(current_animation)
	
func _input(event):
	if event.is_action_pressed("interact") and player and is_awake == false:
		wake_up()
		
		
