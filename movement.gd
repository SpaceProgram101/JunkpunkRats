extends CharacterBody2D

#create variables that access things outside of the main script
@export var float_duration: float = 0.9
@export var float_gravity: float = 0
@export var bullet_scene: PackedScene
@export var spread_angle: float = 90.0
@export var num_projectiles: int = 7
@export var fire_frame: int = 2
@export var projectile_scene: PackedScene
@export var knockback_force = 200.0  # Adjust the knockback strength
@export var knockback_duration = 0.2  # Adjust the knockback duration (in seconds)

@onready var heart_container = $HealthUI
@onready var oil_container = $HealthUI

var suicide = true
var shotgun_spread = 3
var pellets = 15
var overalldirection = 1


var is_shooting: bool = false

var current_spell = 0


var skibidi = 5
var toilet = 5
var max_oil = 3
var current_oil = 3


var frozen: bool = false
const SPEED = 300.0
const JUMP_VELOCITY = -700.0
var gravity = 2500.0

var is_knocked_back = false
var knockback_timer = 0.0
var knockback_direction = Vector2.ZERO

func _ready():
	if $KnockbackTimer:
		$KnockbackTimer.connect("timeout", Callable(self, "_on_KnockbackTimer_timeout"))
	else:
		printerr("ERROR: KnockbackTimer node not found in _ready()!")
	
	$AnimatedSprite2D.connect("frame_changed", Callable(self, "_on_frame_changed"))
	#connect("body_entered", Callable(self, "_on_body_entered"))  # Connect body collision
	#connect("area_entered", Callable(self, "_on_area_entered"))  # Connect area collision


func _process(_delta):
	if Input.is_action_just_pressed("spell"):
		if current_oil > 0:
			current_oil -= 1
			current_spell = 1
			trigger_spell()
		update_oil_ui()
		
	if not is_on_floor() and Input.is_action_just_pressed("up_spell"):
		if current_oil > 0:
			current_oil -= 1
			current_spell = 2
			trigger_spell()
		update_oil_ui()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	#if not on floor, increment velocity by the specified gravity value times the time.
	if not is_on_floor():
		velocity.y += gravity * delta
	#but if you press E while in the air, trigger the cannon
	
	#if floating is set to true, decrease gravity, start the timer

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if Input.is_action_pressed("ui_left"):
		overalldirection = -1
	elif Input.is_action_pressed("ui_right"):
		overalldirection = 1  # Move right
		
	var direction := Input.get_axis("ui_left", "ui_right")
	if not frozen:
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	#
	if velocity.x != 0:
		$AnimatedSprite2D.flip_h = velocity.x < 0
	if current_spell == 1:
		$AnimatedSprite2D.play("bust")
	elif current_spell == 2:
		$AnimatedSprite2D.play("up_spell")
	elif not is_on_floor() and abs(velocity.y) > -1:
		$AnimatedSprite2D.play("fall")
	elif abs(velocity.x) > 0:
		$AnimatedSprite2D.play("run")
	else:
		$AnimatedSprite2D.play("idle")
	
	if is_knocked_back:
		knockback_timer += delta
		if knockback_timer >= knockback_duration:
			is_knocked_back = false
			knockback_timer = 0.0
		else:
			# Apply knockback force (you might need to adjust this based on your movement system)
			velocity = knockback_direction * knockback_force  # For KinematicBody2D
			move_and_slide() # For KinematicBody2D
			# position += knockback_direction * knockback_force * delta #For other Node Types
	move_and_slide()
	
func trigger_spell():
	#set total velocity to 0, tell the player to float, and that you're no longer shooting
	freeze()
	is_shooting = false
	update_oil_ui()



func take_damage(amount: int):
	toilet -= amount
	if toilet < 0:
		toilet = 0
	update_health_ui()
	
func heal(amount: int):
	toilet += amount
	if toilet > skibidi:
		toilet = skibidi
	update_health_ui()
	
func update_health_ui():
	for i in range (skibidi):
		var heart = heart_container.get_child(i)
		if i < toilet:
			heart.texture = preload("res://full_heart.png")
		else:
			heart.texture = preload("res://empty_heart.png")

func update_oil_ui():
	var oil = oil_container.get_child(5)
	if current_oil == 3:
		oil.texture = preload("res://oil_bar/oil_bar_full.png")
	elif current_oil == 2:
		oil.texture = preload("res://oil_bar/oil_bar_2.png")
	elif current_oil == 1:
		oil.texture = preload("res://oil_bar/oil_bar_1.png")
	else: 
		oil.texture = preload("res://oil_bar/oil_bar_empty.png")
		
	
func shoot_shotgun_blasts():
	#im gonna be honest this entire thing is jank as fuck
	#projectiles are made with a certain degree, then converted to radians
	#then we use unit circle to aim them
	#tbh idfk what's going on here it just works sometimes
	is_shooting = false
	var start_angle = -spread_angle / 2
	for i in range(num_projectiles):
		
		var angle_offset = start_angle + (i * (spread_angle / (num_projectiles -1)))
		var angle_rad = deg_to_rad(angle_offset)
		
		var bullet = bullet_scene.instantiate()
		
		if bullet is Area2D:
			
			var direction = Vector2(sin(angle_rad), -cos(angle_rad))
			bullet.direction = direction

			var bullet_position = position + Vector2(-25,-100)
			bullet.position = bullet_position
			
			var bullet_sprite = bullet.get_child(0)	
			var rotation_angle = direction.angle()
			bullet_sprite.rotation = rotation_angle
				
			get_parent().add_child(bullet)
			
	
	unfreeze()
	current_spell = 0
	
	
func launch_shotgun_attack():
	freeze()
	print ("Frozen!")
	for i in range (pellets):
		var angle_offset = (i - (pellets / 2)) * shotgun_spread
		var spawn_angle = rotation + deg_to_rad(angle_offset)  # Rotate relative to player
		print ("Rotation set!")
		# Spawn the projectile
		var projectile = projectile_scene.instantiate()
		get_parent().add_child(projectile)  # Add the projectile to the scene
		print ("Child successfully set!")
			# Position the projectile where the player is
		projectile.position = position  # Spawn at the player's position
		projectile.position.y -= 35
		print("Projectile Rotation: ", projectile.rotation)
		  # Set the projectile's initial rotation
		var direction = Vector2(cos(spawn_angle), sin(spawn_angle))
		if overalldirection < 0:
			direction.x = -direction.x
		projectile.speed = direction * randf_range(800,1200)
		
	unfreeze()
	current_spell = 0
	print ("Bust is false!")



func freeze():
	velocity.x = 0
	velocity.y = 0
	gravity = 0
	frozen = true

func unfreeze():
	frozen = false
	gravity = 2500



func _on_frame_changed():
	if is_shooting:
		return
		
	if $AnimatedSprite2D.frame == fire_frame and current_spell == 2:
		shoot_shotgun_blasts()
		is_shooting = true
	if $AnimatedSprite2D.frame == fire_frame and current_spell == 1:
		launch_shotgun_attack()
		is_shooting = true


		
