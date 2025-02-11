extends CharacterBody2D

#create variables that access things outside of the main script
@export var float_duration: float = 0.9
@export var float_gravity: float = 0
@export var bullet_scene: PackedScene
@export var spread_angle: float = 90.0
@export var num_projectiles: int = 7
@export var fire_frame: int = 2
@export var fire_frame_1: int = 1
@export var sex_force = 700.0  # Adjust the knockback strength
@export var projectile_scene: PackedScene
@export var knockback_force = 200.0  # Adjust the knockback strength
@export var knockback_duration = 0.2  # Adjust the knockback duration (in seconds)

@onready var heart_container = $/root/Node2D/CanvasLayer/HealthUI
@onready var oil_container = $/root/Node2D/CanvasLayer/HealthUI

@onready var afterimage_sprites = [
	$afterimage_1,
	$afterimage_2,
	$afterimage_3
]


var suicide = true

var can_dash: bool = true
var is_dashing: bool = false
var dash_speed: float = 3500.0  # Adjust speed as needed
var dash_time: float = 0.2  # Duration of dash in seconds
var dash_cooldown: float = 1.0  # Cooldown time in seconds

var dash_timer: float = 0.0
var cooldown_timer: float = 0.

var is_jumping = false

var shotgun_spread = 3
var pellets = 50
var overalldirection = 1


var wall_jump_speed = -600
var can_wall_jump = false
var touching_wall = false
var cling = false
var cling_timer = 0.0
var wall_direction = 0

var wall_ray_left : RayCast2D
var wall_ray_right : RayCast2D


var is_shooting: bool = false

var current_spell = 0


var skibidi = 5
var toilet = 5
var max_oil = 3
var current_oil = 3
var immunity = 0

var frozen: bool = false
const SPEED = 200.0
const JUMP_VELOCITY = -600.0
var gravity = 2000.0

var is_knocked_back = false
var knockback_timer = 0.0
var knockback_direction = Vector2.ZERO

func _ready():
	
	wall_ray_left = $WallRayLeft
	wall_ray_right = $WallRayRight

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
	
	
	wall_direction = 0
	
	
	if wall_ray_left.is_colliding():
		touching_wall = true
		wall_direction = -1
	elif wall_ray_right.is_colliding():
		touching_wall = true
		wall_direction = 1
	else:
		touching_wall = false
		wall_direction = 0
		

	# Add the gravity.
	#if not on floor, increment velocity by the specified gravity value times the time.
	if touching_wall and not is_on_floor() and can_wall_jump:
		rotation = 0
		cling = true
		velocity.x = 0
		gravity = 0
		velocity.y = 5
		cling_timer = 0.5
		move_and_slide()
		
	if cling and Input.is_action_just_pressed("ui_accept"):
		velocity.y = wall_jump_speed
		velocity.x = -wall_direction * 600
		cling = false
		can_wall_jump = false
		gravity = 2000
		if wall_direction == 1:
			velocity.x += 100
		elif wall_direction == -1: 
			velocity.x -= 100
			
	elif not is_on_floor() and not touching_wall:
		gravity = 2000.0
		can_wall_jump = true
		if overalldirection == 1:
			rotation = lerp_angle(rotation,-90,0.01)
		elif overalldirection == -1:
			rotation = lerp_angle(rotation,90,0.01)
		velocity.y += gravity * delta
	if is_on_floor():
		rotation = 0
	#but if you press E while in the air, trigger the cannon
	if cling_timer > 0:
		cling_timer -= delta
	else:
		cling = false
	#if floating is set to true, decrease gravity, start the timer
		
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		$AnimatedSprite2D.play("jump")
		velocity.y = JUMP_VELOCITY
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if Input.is_action_pressed("ui_left"):
		overalldirection = 1
	elif Input.is_action_pressed("ui_right"):
		overalldirection = -1  # Move right		
	var direction := Input.get_axis("ui_left", "ui_right")
	if not frozen:
		if direction and can_wall_jump:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	#
	if velocity.x != 0:
		$AnimatedSprite2D.flip_h = velocity.x > 0
	
	
	if cling:
		$AnimatedSprite2D.play("cling")
	elif current_spell == 1:
		$AnimatedSprite2D.play("bust")
	elif current_spell == 2:
		$AnimatedSprite2D.play("up_spell")
	elif not is_on_floor() and abs(velocity.y) > -1:
		$AnimatedSprite2D.play("fall")
	elif abs(velocity.x) > 0:
		$AnimatedSprite2D.play("run")
	else:
		$AnimatedSprite2D.play("idle")
	
	for index in range(get_slide_collision_count()):  # Loop through all collisions
		var collision = get_slide_collision(index)
		var collider = collision.get_collider()

		if collider and collider.is_in_group("enemies"):  # Check if it's an enemy
			if immunity <= 0:
				$AnimatedSprite2D.play("hit")
				take_damage(1)
				apply_knockback(collider.global_position)
				immunity = 1
			else:
				immunity -= delta
	
	
	if Input.is_action_just_pressed("dash") and can_dash and overalldirection != 0:
		is_dashing = true
		can_dash = false
		dash_timer = dash_time
		create_afterimages()
		position.x += (overalldirection*-1) * dash_speed * delta
		  # Set velocity in dash direction
	
	if is_dashing:
		dash_timer -= delta
		if dash_timer <= 0:
			is_dashing = false
			cooldown_timer = dash_cooldown  # Start cooldown
	if not can_dash:
		cooldown_timer -= delta
		if cooldown_timer <= 0:
			can_dash = true  # Reset dash ability
	
	move_and_slide()

func create_afterimages():
	for i in range (afterimage_sprites.size()):
		var afterimage = afterimage_sprites[i]
		var offset = Vector2(-20 * (i+1), 0)
		afterimage.position = position + offset
		afterimage.visible = true
		afterimage.modulate = Color(1, 1, 1, 1) 
		print("Afterimage Position: ", afterimage.position)
		print ("Player position: ", position)
		afterimage.z_index = 10
		
		
		
		var timer = Timer.new()
		add_child(timer)
		timer.wait_time = 0.8 * (i + 1)
		timer.one_shot = true
		timer.connect("timeout", Callable(self,"_on_afterimage_timeout").bind(afterimage, timer))
		timer.start()
		
func _on_afterimage_timeout(afterimage,timer):
	print ("Sprite no longer visible")
	afterimage.visible = false
	afterimage.modulate = Color(1, 1, 1, 1) 
	timer.queue_free()
func apply_knockback(enemy_position: Vector2):
	knockback_direction = (global_position - enemy_position).normalized()

	# Ensure knockback has a strong horizontal component
	if abs(knockback_direction.x) < 0.3:  
		knockback_direction.x = sign(global_position.x - enemy_position.x)

	# Add slight upward force
	knockback_direction.y = -0.3  

	velocity = 2.5*(knockback_direction * sex_force)  # Apply knockback

	# ✅ Now set is_knocked_back AFTER applying knockback
	is_knocked_back = true  
	knockback_timer = 0.0  # Reset timer

	if $KnockbackTimer:
		$KnockbackTimer.start(knockback_duration)
	else:
		printerr("ERROR: KnockbackTimer node not found!")


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
			heart.texture = preload("res://rat_heart_full.png")
		else:
			heart.texture = preload("res://rat_heart_empty.png")

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
	spread_angle = randf_range(-90,90)
	var start_angle = -spread_angle / 2
	for i in range(num_projectiles):
		
		var angle_offset = start_angle + (i * (spread_angle / (num_projectiles -1)))
		var angle_rad = deg_to_rad(angle_offset)
		
		var bullet = bullet_scene.instantiate()
		
		if bullet is Area2D:
			
			var direction = Vector2(sin(angle_rad), -cos(angle_rad))
			bullet.direction = direction

			var bullet_position = position + Vector2(0,-5)
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
		var angle_offset = (i - (pellets / 2.0)) * shotgun_spread
		var spawn_angle = rotation + deg_to_rad(angle_offset)  # Rotate relative to player
		print ("Rotation set!")
		# Spawn the projectile
		var projectile = projectile_scene.instantiate()
		get_parent().add_child(projectile)  # Add the projectile to the scene
		print ("Child successfully set!")
			# Position the projectile where the player is
		projectile.position = position  # Spawn at the player's position
		projectile.position.y -= 5
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
	if $AnimatedSprite2D.frame == fire_frame_1 and current_spell == 1:
		launch_shotgun_attack()
		is_shooting = true


		


func _on_Area2D_body_entered(_Node) -> void:
	pass 


func _on_Area2D_body_exited(_Node) -> void:
	pass 
