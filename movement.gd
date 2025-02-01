extends CharacterBody2D

@export var float_duration: float = 0.9
@export var float_gravity: float = 0
@export var bullet_scene: PackedScene
@export var spread_angle: float = 90.0
@export var num_projectiles: int = 7
@export var fire_frame: int = 2
@export var knockback_force = 200.0  # Adjust the knockback strength
@export var knockback_duration = 0.2  # Adjust the knockback duration (in seconds)

var floating: bool = false
var float_timer: float = 0.0
var is_shooting: bool = false

const SPEED = 300.0
const JUMP_VELOCITY = -700.0
var GRAVITY = 2500.0

var is_knocked_back = false
var knockback_timer = 0.0
var knockback_direction = Vector2.ZERO

func _ready():
	if $KnockbackTimer:
		$KnockbackTimer.connect("timeout", Callable(self, "_on_KnockbackTimer_timeout"))
	else:
		printerr("ERROR: KnockbackTimer node not found in _ready()!")
	
	$AnimatedSprite2D.connect("frame_changed", Callable(self, "_on_frame_changed"))
	connect("body_entered", Callable(self, "_on_body_entered"))  # Connect body collision
	connect("area_entered", Callable(self, "_on_area_entered"))  # Connect area collision

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	if not is_on_floor() and Input.is_action_just_pressed("up_spell"):
		trigger_cannon_attack()

	if floating:
		GRAVITY = float_gravity
		float_timer -= delta
		if float_timer <= 0:
			stop_floating()
			
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if not floating:
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if velocity.x != 0:
		$AnimatedSprite2D.flip_h = velocity.x < 0
	if floating:
		$AnimatedSprite2D.play("up_spell")
	elif not is_on_floor() and abs(velocity.y) > 0:
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
	
func trigger_cannon_attack():
	velocity.x = 0
	velocity.y = 0
	floating = true
	float_timer = float_duration
	is_shooting = false
	
	
	
func shoot_shotgun_blasts():
	
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
			


func stop_floating():
	floating = false;
	GRAVITY = 2500


func _on_frame_changed():
	if is_shooting:
		return
	
	if $AnimatedSprite2D.frame == fire_frame and floating == true:
		shoot_shotgun_blasts()
		is_shooting = true

		
func _on_area_entered(area):
	_handle_collision(area)

func _on_body_entered(body):
	_handle_collision(body)

func _handle_collision(other_node):
	if is_knocked_back:
		return  # Prevent multiple knockbacks in quick succession

	if other_node.has_meta("knockback"):  # Only apply knockback to objects with this meta
		var enemy_position = other_node.global_position

		# Call the knockback function to apply the force
		apply_knockback(knockback_force, knockback_duration, enemy_position)

func apply_knockback(force: float, duration: float, enemy_position: Vector2):
	if is_knocked_back:
		return  # Prevent multiple knockbacks in quick succession

	print("apply_knockback called from:", enemy_position)  # Debugging
	print("Player position:", position)

	is_knocked_back = true
	knockback_timer = 0.0

	# Calculate knockback direction (push the player away from the enemy)
	knockback_direction = (position - enemy_position).normalized()

	# Ensure that we don't have weak horizontal knockback
	if abs(knockback_direction.x) < 0.1:  # If horizontal force is too small, set it to a valid direction
		knockback_direction.x = sign(position.x - enemy_position.x)  # Correctly force direction based on x

	print("Knockback Direction:", knockback_direction)

	# Apply knockback force
	velocity = knockback_direction * force

	if $KnockbackTimer:
		$KnockbackTimer.start(duration)
	else:
		printerr("ERROR: KnockbackTimer node not found!")
func _on_KnockbackTimer_timeout():
	is_knocked_back = false
