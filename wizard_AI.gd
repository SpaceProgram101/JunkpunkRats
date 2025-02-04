extends CharacterBody2D

@export var fireball_scene : PackedScene
@export var max_health: int = 50
var current_health: int
var shoot_interval = 2  # Time in seconds between shots
var next_shoot_time = 0.0
var speed = 100
var direction = -1
var dead = false
var dying = false
var gravity = 500
var audio_player: AudioStreamPlayer2D
var player  # Reference to the player node
var attack_range = 300.0
var start_position = Vector2()

@export var portal_scene : PackedScene  # Portal scene
var portal_effect : Node2D = null

func _ready():
	audio_player = $gleb_rat
	current_health = max_health
	next_shoot_time = shoot_interval
	start_position = position
	fireball_scene = preload("res://wizard_fireball.tscn")
	player = get_tree().root.get_node("Node2D/Player")  # Make sure to set this to your player node path
	portal_scene = preload("res://blue_explosion_scene.tscn")
	
func _process(delta):
	if player:
		var distance_to_player = position.distance_to(player.position)
		
		if dead:
			if not is_on_floor():
				$AnimatedSprite2D.play("falling")
				position.y += gravity * delta
			elif is_on_floor():
				$AnimatedSprite2D.play("dead")
		elif distance_to_player <= attack_range:
			$AnimatedSprite2D.play("rat_angy")
			next_shoot_time -= delta
			if next_shoot_time <= 0:
				shoot_fireball()
				next_shoot_time = shoot_interval  # Reset the shooting timer
		else:
			$AnimatedSprite2D.play("rat_idle")
			position.x += speed * direction * delta
			move_and_slide()
		move_and_slide()
		# Flip sprite based on direction
		if direction == -1:
			$AnimatedSprite2D.flip_h = true # Flip sprite horizontally to face left
		elif direction == 1:
			$AnimatedSprite2D.flip_h = false  # Flip sprite horizontally to face right

	# Flip direction when reaching a certain distance
		if position.x > start_position.x + 200:  # Move right 200 pixels from start position
			direction = -1  # Move left
		elif position.x < start_position.x - 200:  # Move left 200 pixels from start position
			direction = 1  # Move right
			
			
func shoot_fireball():
	var fireball = fireball_scene.instantiate()  # Use instantiate() instead of instance()
	fireball.position = position  # Shoot from enemy's position
	fireball.position.y -= 75
	
	fireball.set_direction(player.position)
	get_parent().add_child(fireball)
	spawn_portal_effect()
	
	
func spawn_portal_effect():
	if portal_effect == null:
		portal_effect = portal_scene.instantiate()
		get_parent().add_child(portal_effect)
		portal_effect.position = position
		portal_effect.position.y -=75
		var animated_sprite = portal_effect.get_node("summonSprite2D")
		animated_sprite.play("summon")
		
		await animated_sprite.animation_finished
		portal_effect.queue_free()

func take_damage(damage: int) -> void:
	current_health -= damage
	if current_health <= 0:
		audio_player.play()
		dead = true
