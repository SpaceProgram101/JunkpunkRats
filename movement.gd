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
@onready var powerTimer = $powerTimer  # Powerup timer

@onready var dash_effect = preload("res://afterimage.tscn")

@onready var smoke = $Smoke_Bomb
@onready var afterimage_sprites = [
	$afterimage_1,
	$afterimage_2,
	$afterimage_3
]

@onready var footstep_audio = $AudioStreamPlayer2D
@onready var boing = $AudioBoing

#//////////// ATTACK VARIABLES //////////// 
var attack_cooldown = 0.5
var attack_range = 50
var attack_damage = 10
var can_attack = true
var attack_area : Area2D
@onready var attack_timer = $Attack_Timer
var suicide = true
@onready var cannon = get_node("/root/Node2D/Cannon")

#//////////// DASHING VARIABLES //////////// 
var can_dash: bool = true
var is_dashing: bool = false
var dash_speed: float = 150.0  # Adjust speed as needed
var dash_time: float = 0.25  # Duration of dash in seconds
var dash_cooldown: float = 0.5  # Cooldown time in seconds
var dash_timer: float = 0.0
var cooldown_timer: float = 0.
var dash_clone = 10
var is_jumping = false
var recharging = false

#//////////// SPELL VARIABLES //////////// 
var shotgun_spread = 3
var pellets = 50
var overalldirection = 1
var is_shooting: bool = false
var current_spell = 0


#//////////// WALLJUMP VARIABLES //////////// 
var wall_jump_speed = -600
var can_wall_jump = false
var touching_wall = false
var cling = false
var cling_timer = 0.0
var wall_direction = 0
var wall_ray_left : RayCast2D
var wall_ray_right : RayCast2D
var has_touched_wall = false

#//////////// PLAYER VARIABLES //////////// 
@onready var healthbar = get_node("/root/Node2D/CanvasLayer/PlayerBar")
var skibidi = 5
var toilet = 5
var max_oil = 3
var current_oil = 3
var immunity = 0
var immune = false
var dead = false
var dying = false
var idle = false

#//////////// MOVEMENT VARIABLES //////////// 
var prev_velocity = Vector2(0,0)
var frozen: bool = false
var SPEED = 200.0 #WHEN CHANGING REMEMBER TO CHANGE IN POWERUP FUNCTIONS TOO
var JUMP_VELOCITY = -305.0 #WHEN CHANGING REMEMBER TO CHANGE IN POWERUP FUNCTIONS TOO
const GRAVITY = 880.0
var gravity = 980.0

var is_knocked_back = false
var knockback_timer = 0.0
var knockback_direction = Vector2.ZERO

# Respawn vars
var respawn_position: Vector2
var has_respawn_point: bool = false
var kms = false

func _ready():
	skibidi = 100
	healthbar.init_health(skibidi)
	respawn_position = position
	has_respawn_point = true
	smoke.visible = false
	
	wall_ray_left = $WallRayLeft
	wall_ray_right = $WallRayRight
	if $KnockbackTimer:
		$KnockbackTimer.connect("timeout", Callable(self, "_on_KnockbackTimer_timeout"))
	else:
		printerr("ERROR: KnockbackTimer node not found in _ready()!")
	
	$AnimatedSprite2D.connect("frame_changed", Callable(self, "_on_frame_changed"))
	
	powerTimer.connect("timeout", Callable(self, "_on_timer_timeout")) 

func _physics_process(delta: float) -> void:
	move_and_slide()
	if Input.is_action_just_pressed("DIE"):
		kms = true
		
	if position.y > 1000.0:
		position = respawn_position
		take_damage(30)
	
	wall_direction = 0
		
	# Add the gravity.
	#if not on floor, increment velocity by the specified gravity value times the time.
	if is_on_wall() and not is_on_floor():
		rotation = 0
		cling = true
		velocity.x = 0
		gravity = 0
		velocity.y = 1
		if not has_touched_wall:
			$AudioWallJump.play()
			has_touched_wall = true
	
	if cling and Input.is_action_just_pressed("ui_accept") and not dead:
		velocity.y -= 300
		$AudioWallJump.play()
		cling = false
		gravity = GRAVITY
		if overalldirection == 1:
			position.x  += 15
		elif overalldirection == -1: 
			position.x -= 15
			
	elif not is_on_floor() and not is_on_wall() and not dead:
		gravity = GRAVITY
		cling = false
		velocity.y += gravity * delta
		
	#but if you press E while in the air, trigger the cannon
	
	# Handle jump.
	
	if Input.is_action_just_pressed("ui_accept") and is_on_floor() and not dead:
		$/root/Node2D/Cannon.visible = false
		$AnimatedSprite2D.play("jump")
		$Jump.play()
		velocity.y = JUMP_VELOCITY * 1.2
	elif Input.is_action_just_pressed("ui_accept") and dead:
		$death_screen.visible = false
		dead = false
		dying = false
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if Input.is_action_pressed("ui_left"):
		overalldirection = 1
		
	elif Input.is_action_pressed("ui_right"):  # Move right		
		overalldirection = -1
		
		
	if not is_on_floor() or frozen:
		footstep_audio.stop()
			
	var direction := Input.get_axis("ui_left", "ui_right")
	if not frozen and not dead and not is_dashing:
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			footstep_audio.play()
	if frozen:
		velocity = Vector2(0,0)
	if velocity.x == 0 and not cannon.shooting and abs(velocity.y) == 0:
		idle = true
	elif abs(velocity.x) > 0 or cannon.shooting or abs(velocity.y) > 0:
		idle = false
		
	if overalldirection == -1 and not cling:
		#$Sprite2D.flip_h = true
		$AnimatedSprite2D.flip_h = true
	elif overalldirection == 1 and not cling:
		#$Sprite2D.flip_h  = false
		$AnimatedSprite2D.flip_h = false
	elif overalldirection == -1 and cling:
		#$Sprite2D.flip_h = false
		$AnimatedSprite2D.flip_h = false
	elif overalldirection == 1 and cling:
		#$Sprite2D.flip_h = true
		$AnimatedSprite2D.flip_h = true
	if dying:
		$AnimatedSprite2D.play("grave")
		await $AnimatedSprite2D.animation_finished
		dead = true
		dying = false
	elif dead:
		$death_screen.visible = true
		$AnimatedSprite2D.play("dead_idle")
	elif cling:
		$AnimatedSprite2D.play("cling")
	elif current_spell == 1:
		$AnimatedSprite2D.play("bust")
	elif current_spell == 2:
		$AnimatedSprite2D.play("up_spell")
	elif not is_on_floor() and abs(velocity.y) > -1:
		$AnimatedSprite2D.play("fall")
	elif abs(velocity.x) > 0:
		$AnimatedSprite2D.play("run")
	elif cannon.shooting:
		$AnimatedSprite2D.play("shoot")
	else:
		$AnimatedSprite2D.play("idle")
		
	if is_on_floor():
		#$Sprite2D.visible = true
		$/root/Node2D/Cannon.visible = true
	
	if Input.is_action_just_pressed("dash") and can_dash:
		$squeak.play()
		immune = true
		is_dashing = true
		can_dash = false
		dash_timer = dash_time
		smoke.top_level = true
		smoke.visible = true
		smoke.position = position
		smoke.play("default")
		velocity.x += (overalldirection*-1) * (dash_speed * 2)
		velocity.y -= dash_speed
		await smoke.animation_finished
		smoke.visible = false
		
		  # Set velocity in dash direction
	
	if is_dashing:
		create_afterimages()
		dash_timer -= delta
		if dash_timer <= 0:
			is_dashing = false
			immune = false
			cooldown_timer = dash_cooldown  # Start cooldown
	if not can_dash and not is_dashing:
		cooldown_timer -= delta
		if cooldown_timer <= 0:
			healthbar.dash = 100
			can_dash = true  # Reset dash ability
	

	
func _on_area_entered(area):
	if area.is_in_group("void"):
		die()

func create_afterimages():
	var dash = dash_effect.instantiate()
	
	dash.position = position
	add_child(dash)
	dash_clone -= 1
	if dash_clone > 0:
		var timer = $Timer
		timer.wait_time = 0.1
		timer.one_shot = false
		timer.start()
		
		await timer.timeout
		create_afterimages()
		
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





func take_damage(amount: int):
	print ("Damage was taken, immunity status: ", immune)
	if not dead:
		skibidi -= amount
		if skibidi > 0:
			healthbar.health = skibidi
	if skibidi <= 0:
		die()
	immune = true
	var immunity_timer = Timer.new()
	add_child(immunity_timer)
	immunity_timer.wait_time = 0.3
	immunity_timer.one_shot = true
	immunity_timer.start()
	await immunity_timer.timeout
	immune = false
		
	
func heal(amount: int):
	if ((skibidi + amount) > 125):
		skibidi = 125
	else:
		skibidi += amount
		healthbar.health = skibidi
		
func die():
	if not dead:
		dying = true
		await get_tree().create_timer(1.5).timeout  # Delay before showing respawn screen
		dead = true
		velocity = Vector2(0,0)
		show_respawn_screen()
		healthbar.health = 0
	
func set_respawn_point(new_position: Vector2):
	respawn_position = new_position
	has_respawn_point = true
	
func show_respawn_screen():
	$death_screen.visible = true
	while dead:
		await get_tree().process_frame
		if Input.is_action_just_pressed("ui_accept"):
			respawn()

func respawn():
	if has_respawn_point:
		position = respawn_position
		skibidi = 125  # Reset health
		if is_instance_valid(healthbar):
			healthbar.health = skibidi
		$death_screen.visible = false
		dead = false
		dying = false
	else:
		print("No respawn point set!")

func iwanttokillmyselfsomuchyoudontevenunderstandlikewhyareweevendoingthiswecouldhaveboughtourowntriptoshanghaiandnotbotheredwithallofthismesslikeholyshitihategodotsomuchitisaterribledeviceformakinggameswhydidntwejustlearnunity():
	JUMP_VELOCITY -= 100.0
	powerTimer.start()

func highSpeed():
	SPEED += 50.0
	powerTimer.start()

func _on_timer_timeout():
	SPEED = 200.0 
	JUMP_VELOCITY = -305.0 
