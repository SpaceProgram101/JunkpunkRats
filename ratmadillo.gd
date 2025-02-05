extends CharacterBody2D


var speed = 100 # Walking speed
var fly_speed = 300 # Flying speed
var direction = 1 # 1 for right, -1 for left
var is_player_detected = false # To detect if the player is seen

var detection_area : Area2D
var player : CharacterBody2D # Reference to the player node
var start_position = Vector2()
var anim : AnimatedSprite2D
@onready var walk_timer : Timer = $WalkTimer

func _ready():
	start_position = position
	anim = $AnimatedSprite2D
	detection_area = $Area2D
	player = get_node("/root/Node2D/Player")


	walk_timer.connect("timeout", Callable(self, "_on_walk_timeout"))
	walk_timer.start()
	
	detection_area.connect("area_entered", Callable(self, "_on_player_detected"))
	detection_area.connect("area_exited", Callable(self, "_on_player_lost"))
	
	anim.play("walk")

func _process(delta):
	# Add the gravity.
	if is_player_detected:
		return
	else:
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
		move_and_slide()
	
func _on_walk_timeout():
	direction = -direction
	
func _on_player_detected(body):
	if body == player:
		is_player_detected = true
		anim.play("prep")
		
		await anim.animation_finished
		anim.play("roll")

		_fly_across()
		
func _on_player_lost(body):
	if body == player:
		is_player_detected = false
		anim.play("walk")
		direction = 1

func _fly_across():
	var target_position = position + Vector2(500 * direction, 0)
	
	while position.distance_to(target_position) > 10:
		var _movement = Vector2(fly_speed * direction, 0)
		move_and_slide()
		await get_tree().idle_frame()
	anim.play("walk")
	walk_timer.start()
	direction = -direction
